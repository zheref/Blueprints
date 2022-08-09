import Foundation
import RxSwift
import FirebaseFirestore
import os

class FirestoreAssignmentsService: IAssignmentsServive {
    
    // MARK: - Class Members
    
    static let collectionName = "assignments"
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FirestoreAssignmentsService.self)
    )
    
    static func assignmentsMap(from documents: [RawDocument]) -> AssignmentsMap {
        var assignmentsDictionary = AssignmentsMap()
        for doc in documents {
            if let dateName = doc["date"] as? String, let blueprintRef = doc["print"] as? DocumentReference {
                assignmentsDictionary[dateName] = blueprintRef.path
            } else if let dateName = doc["date"] as? String, let blueprintPath = doc["print"] as? String {
                assignmentsDictionary[dateName] = blueprintPath
            } else {
                Self.logger.error("Date or print in assignment not string or document compliant")
                break
            }
        }
        return assignmentsDictionary
    }
    
    // MARK: - Instance Members
    
    let blueprintsService: IBlueprintsService
    let authService: IAuthService
    let daysService: DaysServiceProtocol
    
    init(authService: IAuthService, blueprintsService: IBlueprintsService, daysService: DaysServiceProtocol) {
        self.authService = authService
        self.blueprintsService = blueprintsService
        self.daysService = daysService
    }
    
    func assign(bprint: Blueprint, toDate date: BlueDate, forUserId userId: String) -> Single<Void> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        guard let dateString = date.toString() else {
            return Single.error(AssignmentsServiceError.dateNotValid)
        }
        
        guard let printID = bprint.documentID else {
            return Single.error(BlueError.noIdentifier)
        }
        
        let assignmentData: [String: Any] = [
            "date": dateString,
            "print": bprint.privacy == .privately
            ? firestore.document("/users/\(userId)/blueprints/\(printID)")
            : firestore.document("/blueprints/\(printID)")
        ]
        
        return Single.create { [assignmentData, userId] trigger in
            firestore
                .document("/users/\(userId)")
                .collection(Self.collectionName)
                .document(dateString)
                .setData(assignmentData) { error in
                    if let error = error {
                        Self.logger.error("[Assigning Day] \(error.localizedDescription)")
                        trigger(.failure(error))
                    } else { trigger(.success(Void())) }
                }
            
            return Disposables.create { }
        }
    }

    func unassign(date: BlueDate, forUserId userId: String) -> Completable {
        let firestore = try! firebaseInjector.resolve() as Firestore

        guard let dateString = date.toString() else {
            return Completable.error(AssignmentsServiceError.dateNotValid)
        }

        return Completable.create { complete in
            firestore
                .document("/users/\(userId)")
                .collection(Self.collectionName)
                .document(dateString)
                .delete { error in
                    if let error = error {
                        Self.logger.error("[Unassigning Day] \(error.localizedDescription)")
                        complete(.error(error))
                    } else { complete(.completed) }
                }

            return Disposables.create()
        }
    }
    
    func fetchAndMix(withDates dates: [BlueDate]) -> Observable<[Day]> {
        fetchAndParse(forDates: dates).map { assignments in
            return dates.map({ date in
                guard let matchingAssignment = assignments.first(where: { $0.date == date }) else {
                    return RedDay(date: date)
                }
                
                return BlueDay(date: date, blueprint: matchingAssignment.print, completion: nil)
            })
        }
    }
    
    func fetchAndParse(forDates dates: [BlueDate]) -> Observable<[Assignment]> {
        return Observable.combineLatest(
            blueprintsService.fetchForContext(forUserId: authService.currentUserId),
            fetch(forDates: dates, forUserId: authService.currentUserId)
        ).map { groupedBlueprints, assignmentsMap in
            let allBlueprints = groupedBlueprints.public + groupedBlueprints.private
            return assignmentsMap.compactMap { dateString, printRef in
                guard let blueprint = allBlueprints.first(where: { $0.firePath == ZPath.from(string: printRef) }) else {
                    Self.logger.error("Blueprint with documentID(\(printRef) not found")
                    return nil
                }
                
                guard let blueDate = BlueDate.from(string: dateString) else {
                    Self.logger.error("Date string (\(dateString) not parseable to BlueDate")
                    return nil
                }
                
                return Assignment(date: blueDate, print: blueprint)
            }
        }
    }
    
    func fetch(forDates dates: [BlueDate],
               forUserId userId: String) -> Observable<AssignmentsMap> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        return Observable.create { [dates] observer in
            let listener = firestore
                .document("users/\(userId)")
                .collection(Self.collectionName)
                .whereField("date", in: dates.compactMap { $0.toString() })
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        Self.logger.error("\(error.localizedDescription)")
                        observer.on(.error(error))
                    }
                    
                    guard let docs = snapshot?.documents else { return }
                    observer.onNext(
                        Self.assignmentsMap(from: docs.map { $0.data() })
                    )
                }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
}
