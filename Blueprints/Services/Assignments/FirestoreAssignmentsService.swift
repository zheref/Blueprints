import Foundation
import RxSwift
import FirebaseFirestore
import os

class FirestoreAssignmentsService: AssignmentsServiceProtocol {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FirestoreAssignmentsService.self)
    )
    
    static let collectionName = "assignments"
    
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
                        print("Error assigning day:", error.localizedDescription)
                        trigger(.failure(error))
                    }
                    
                    trigger(.success(Void()))
                }
            
            return Disposables.create { }
        }
    }
    
    static func assignmentsMap(from documents: [RawDocument]) -> AssignmentsMap {
        var assignmentsDictionary = AssignmentsMap()
        for doc in documents {
            guard let dateName = doc["date"] as? String, let blueprintRef = doc["print"] as? DocumentReference else {
                Self.logger.error("Date or print in assignment not string or document compliant")
                break
            }
            assignmentsDictionary[dateName] = blueprintRef.path
        }
        return assignmentsDictionary
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
                    let assignmentsDict = Self.assignmentsMap(from: docs.map { $0.data() })
                    observer.on(.next(assignmentsDict))
                }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
}
