import Foundation
import Dip

enum BlueError: Error {
    case noIdentifier
}

protocol ServiceProtocol {
    var servicesInjector: DependencyContainer { get }
    var firebaseInjector: DependencyContainer { get }
}

extension ServiceProtocol {
    var servicesInjector: DependencyContainer {
        return ServicesContainer.shared
    }
    
    var firebaseInjector: DependencyContainer {
        return FirebaseContainer.shared
    }
}
