import Foundation
import Dip
import FirebaseFirestore

class FirebaseContainer {
    static let shared: DependencyContainer = {
        let container = DependencyContainer()
        container.register { Firestore.firestore() as Firestore }
        return container
    }()
}
