//
//  FirestoreBlueprintsService.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift
import FirebaseFirestore
import os

class FirestoreBlueprintsService: IBlueprintsService, Loggable {
    
    static var logCategory: String { String(describing: FirestoreBlueprintsService.self) }
    
    // MARK: - Class Members
    
    static let collectionName = "blueprints"
    
     // MARK: - Instance Members
    
    var privateCache = [String: Blueprint]()
    var publicCache = [String: Blueprint]()
    
    func entity(fromDoc doc: DocumentSnapshot) -> Blueprint? {
        guard let name = doc["name"] as? String, let attribute = doc["attribute"] as? String else {
            Self.logger.error("Missing name and/or attribute data to build a blueprint")
            return nil
        }
        
        var resolvedTransport = TransportationMethod.any
        if let transportStr = doc["transport"] as? String,
           let transport = TransportationMethod(rawValue: transportStr) {
            resolvedTransport = transport
        }
        
        var resolvedSystem = SystemType.free
        if let systemStr = doc["system"] as? String, let system = SystemType(rawValue: systemStr) {
            resolvedSystem = system
        }
        
        var resolvedMusic = MusicType.any
        var resolvedArtists: [String]?
        if let musicStr = doc["music"] as? String, let music = MusicType(rawValue: musicStr) {
            resolvedMusic = music
            if let artists = doc["artists"] as? [String] {
                resolvedArtists = artists
            }
        }
        
        var resolvedColors: [PrintColor] = [.black, .white, .brown]
        if let colors = doc["colors"] as? [String] {
            resolvedColors = colors.compactMap { PrintColor(rawValue: $0) }
        }
        
        let resolvedNotes = (doc["notes"] as? [String]) ?? [String]()
        
        var resolvedClothesStyles = [ClothesStyle]()
        if let clothes = doc["clothes"] as? [String] {
            resolvedClothesStyles = clothes.compactMap { ClothesStyle(rawValue: $0) }
        }
        
        var resolvedWork = [WorkPlacement]()
        if let work = doc["work"] as? [[String: Any]] {
            resolvedWork = work.map { (placement) -> WorkPlacement in
                var resolvedEnvironment = WorkEnvironment.none
                if let environmentStr = placement["environment"] as? String,
                   let environment = WorkEnvironment(rawValue: environmentStr) {
                    resolvedEnvironment = environment
                }
                
                var resolvedMode = WorkMode.any
                if let modeStr = placement["mode"] as? String,
                   let mode = WorkMode(rawValue: modeStr) {
                    resolvedMode = mode
                }
                
                return WorkPlacement(
                    minutes: placement["minutes"] as? Int ?? 0,
                    environment: resolvedEnvironment,
                    mode: resolvedMode,
                    specifics: placement["specifics"] as? String
                )
            }
        }

        var resolvedTrain = [TrainingPlacement]()
        if let training = doc["training"] as? RegularDict {
            var resolvedEnvironment = TrainingEnvironment.none
            if let environmentStr = training["environment"] as? String,
                let environment = TrainingEnvironment(rawValue: environmentStr) {
                resolvedEnvironment = environment
            }

            var resolvedWays = [TrainingWay]()
            if let stringWays = training["ways"] as? [String] {
                resolvedWays = stringWays.compactMap { TrainingWay(rawValue: $0) }
            }

            resolvedTrain = [TrainingPlacement(
                    minutes: training["minutes"] as? Int ?? 0,
                    environment: resolvedEnvironment,
                    ways: resolvedWays,
                    specifics: training["specifics"] as? String
            )]
        } else if let train = doc["train"] as? [RegularDict] {
            resolvedTrain = train.map { placement -> TrainingPlacement in
                var resolvedEnvironment = TrainingEnvironment.none
                if let environmentStr = placement["environment"] as? String,
                   let environment = TrainingEnvironment(rawValue: environmentStr) {
                    resolvedEnvironment = environment
                }
                
                var resolvedWays = [TrainingWay]()
                if let stringWays = placement["ways"] as? [String] {
                    resolvedWays = stringWays.compactMap { TrainingWay(rawValue: $0) }
                }
                
                return TrainingPlacement(
                    minutes: placement["minutes"] as? Int ?? 0,
                    environment: resolvedEnvironment,
                    ways: resolvedWays,
                    specifics: placement["specifics"] as? String
                )
            }
        }
        
        var resolvedChill = [ChillPlacement]()
        if let chill = doc["chill"] as? [RegularDict] {
            resolvedChill = chill.map { placement -> ChillPlacement in
                var resolvedEnvironment = ChillEnvironment.none
                if let environmentStr = placement["environment"] as? String,
                   let environment = ChillEnvironment(rawValue: environmentStr) {
                    resolvedEnvironment = environment
                }
                
                var resolvedWays = [ChillWay]()
                if let stringWays = placement["ways"] as? [String] {
                    resolvedWays = stringWays.compactMap { ChillWay(rawValue: $0) }
                }
                
                return ChillPlacement(
                    minutes: placement["minutes"] as? Int ?? 0,
                    environment: resolvedEnvironment,
                    ways: resolvedWays,
                    specifics: placement["specifics"] as? String
                )
            }
        }
        
        let bprint = Blueprint(name: name, attribute: attribute,
                               pictureUrl: doc["pictureUrl"] as? String,
                               transport: resolvedTransport,
                               system: resolvedSystem,
                               colors: resolvedColors,
                               music: resolvedMusic,
                               artists: resolvedArtists,
                               work: resolvedWork,
                               train: resolvedTrain,
                               chill: resolvedChill,
                               clothesStyles: resolvedClothesStyles,
                               notes: resolvedNotes,
                               documentID: doc.documentID,
                               firePath: ZPath.from(string: doc.reference.path))
        
        return bprint
    }
    
    private func lookup(withPath path: String) -> Blueprint? {
        publicCache[path] ?? privateCache[path]
    }
    
    func fetch(forPath path: String) -> Maybe<Blueprint> {
        let fs = try! firebaseInjector.resolve() as Firestore
        
        return Maybe<Blueprint>.create { [fs, weak self] maybe in
            if let cached = self?.lookup(withPath: path) {
                maybe(.success(cached))
            } else {
                fs.document(path).getDocument { [weak self] snapshot, error in
                    guard let docSnapshot = snapshot, docSnapshot.exists else {
                        if let error = error {
                            Self.logger.error("Single blueprint fetch error \(error.localizedDescription)")
                            maybe(.error(error))
                        } else {
                            Self.logger.error("Document with path \(path) does not seem to exist")
                            maybe(.completed)
                        }
                        
                        return
                    }
                    
                    guard let this = self else {
                        maybe(.completed)
                        return
                    }
                    
                    let isPublic = path.starts(with: "/blueprints")
                    
                    if isPublic, let poso = this.entity(fromDoc: docSnapshot)?.asPublic() {
                        this.publicCache[path] = poso
                        maybe(.success(poso))
                    } else if let poso = this.entity(fromDoc: docSnapshot) {
                        this.privateCache[path] = poso
                        maybe(.success(poso))
                    } else {
                        maybe(.completed)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    private var sharedContextFetch: Observable<GroupedBlueprints>!
    
    func fetchForContext(forUserId userId: String) -> Observable<GroupedBlueprints> {
        if let prevFetch = sharedContextFetch {
            Self.logger.info("Reusing previous shared context fetch")
            return prevFetch
        }
        
        Self.logger.info("Resolving new shared context fetch")
        sharedContextFetch = Observable.combineLatest(
            fetchAll(),
            fetch(fromUser: userId)
        ).map {
            (public: $0, private: $1)
        }.share(replay: 1)
        
        return sharedContextFetch
    }
    
    func fetchBriefingRows(forUserId userId: String) -> Observable<[BriefingRow]> {
        return fetchForContext(forUserId: userId).map {
            Array<BriefingRow>([
                ("My blueprints", .suggestions(blueprints: $0.private, userId: userId)),
                ("All blueprints", .suggestions(blueprints: $0.public, userId: nil))
            ])
        }
    }
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        return Observable.create { [userId] observer in
            let userPath = "/users/\(userId)"
            
            let listener = firestore
                .document(userPath)
                .collection(Self.collectionName)
                .addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else {
                        if let error = error {
                            Self.logger.error("Private blueprints error \(error.localizedDescription)")
                            observer.on(.error(error))
                        }
                        return
                    }
                    
                    let prints = snapshot.documents.compactMap { self.entity(fromDoc: $0) }
                    prints.forEach { [unowned self] bprint in
                        guard let docId = bprint.documentID else { return }
                        let fullPath = "\(userPath)/\(Self.collectionName)/\(docId)"
                        self.privateCache[fullPath] = bprint
                    }
                    
                    observer.onNext(prints)
                }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    func fetchAll() -> Observable<[Blueprint]> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        return Observable.create { observer in
            let listener = firestore
                .collection(Self.collectionName)
                .addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else {
                        if let error = error {
                            Self.logger.error("Public blueprints error \(error.localizedDescription)")
                            observer.on(.error(error))
                        }
                        
                        return
                    }
                    
                    let prints = snapshot.documents.compactMap { self.entity(fromDoc: $0)?.asPublic() }
                    prints.forEach { [unowned self] bprint in
                        guard let docId = bprint.documentID else { return }
                        let fullPath = "/\(Self.collectionName)/\(docId)"
                        self.publicCache[fullPath] = bprint
                    }
                    
                    observer.onNext(prints)
                }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
}
