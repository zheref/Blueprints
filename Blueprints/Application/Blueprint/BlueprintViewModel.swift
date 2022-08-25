import Foundation
import RxSwift

enum BlueprintViewEvent {
    case ready
}

class BlueprintViewModel: BlueViewModel {
    
    let event = PublishSubject<BlueprintViewEvent>()
    
    let blueprint: Blueprint
    
    init(blueprint: Blueprint) {
        self.blueprint = blueprint
    }
    
}
