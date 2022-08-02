//
//  FirestoreBlueprintsService.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift
import FirebaseFirestore

class FirestoreBlueprintsService: BlueprintsServiceProtocol {
    
    static let collectionName = "blueprints"
    
    func entity(fromDoc doc: QueryDocumentSnapshot) -> Blueprint? {
        guard let name = doc["name"] as? String, let attribute = doc["attribute"] as? String else {
            print("Error:", "Missing name and/or attribute data to build a blueprint")
            return nil
        }
        
        return Blueprint(name: name, attribute: attribute,
                         pictureUrl: doc["pictureUrl"] as? String,
                         work: [],
                         train: [],
                         documentID: doc.documentID)
    }
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        return Observable.create { [userId] observer in
            let listener = firestore
                .document("/users/\(userId)")
                .collection(Self.collectionName)
                .addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else {
                        if let error = error {
                            print("Private blueprints error", error)
                            observer.on(.error(error))
                        }
                        return
                    }
                    
                    observer.onNext(
                        snapshot.documents.compactMap { self.entity(fromDoc: $0) }
                    )
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
                            print("Public blueprints error", error)
                            observer.on(.error(error))
                        }
                        
                        return
                    }
                    
                    observer.onNext(
                        snapshot.documents.compactMap { self.entity(fromDoc: $0)?.asPublic() }
                    )
                }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
}
