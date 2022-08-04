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
    
    var privateCache = [String: Blueprint]()
    var publicCache = [String: Blueprint]()
    
    func entity(fromDoc doc: DocumentSnapshot) -> Blueprint? {
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
                            print("Single blueprint fetch error", error.localizedDescription)
                            maybe(.error(error))
                        } else {
                            print("Document with path \(path) does not seem to exist")
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
                            print("Private blueprints error", error)
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
                            print("Public blueprints error", error)
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
