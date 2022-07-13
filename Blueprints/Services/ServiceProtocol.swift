import Foundation
import Dip

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
