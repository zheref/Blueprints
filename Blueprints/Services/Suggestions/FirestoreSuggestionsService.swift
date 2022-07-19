import RxSwift
import FirebaseFirestore

class FirestoreSuggestionsService: SuggestionsServiceProtocol {
    static let collectionName = "suggestions"
    
    func entity(fromDoc doc: QueryDocumentSnapshot) -> SuggestionsBox {
        SuggestionsBox(title: doc["title"] as? String ?? "", prints: [], forUser: "")
    }
    
    func fetch(forUser userId: String) -> Observable<[SuggestionsBox]> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        return Observable.create { [firestore, userId] observer in
            let listener = firestore.collection(Self.collectionName)
                .whereField("forUser", isEqualTo: firestore.document("/users/\(userId)"))
                .addSnapshotListener({ snapshot, error in
                    guard let snapshot = snapshot else {
                        if let error = error {
                            print("Suggestions error", error)
                            observer.on(.error(error))
                        }
                        
                        return
                    }
                    
                    observer.on(
                        .next(snapshot.documents.map { self.entity(fromDoc: $0) })
                    )
                })
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
}
