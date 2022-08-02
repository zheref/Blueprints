import Foundation
import Dip
import FirebaseFirestore
import FirebaseStorage

class FirebaseContainer {
    static let shared: DependencyContainer = {
        let container = DependencyContainer()
        container.register { Firestore.firestore() as Firestore }
        container.register { Storage.storage() as Storage }
        return container
    }()
}
