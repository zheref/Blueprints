import Foundation
import RxSwift

enum BlueprintViewEvent {
    case preparing
    case ready
}

struct AspectModel {
    enum Kind {
        case colors
        case simple
    }
    
    let kind: Kind
    let caption: String
    let associatedValue: Any
}

class BlueprintViewModel: BlueViewModel {
    
    enum Section {
        case blueprint(aspects: [AspectModel])
        case history
    }
    
    let event = PublishSubject<BlueprintViewEvent>()
    
    let blueprint: Observable<Blueprint>
    let sections: Observable<[Section]>
    
    init(blueprint: Blueprint) {
        self.blueprint = Observable.of(blueprint)
        
        sections = self.blueprint.map({ bprint in
            let aspects = [
                AspectModel(kind: .simple, caption: "System", associatedValue: bprint.system.name),
                AspectModel(kind: .colors, caption: "Colors", associatedValue: bprint.colors)
            ]
            
            return [
                Section.blueprint(aspects: aspects),
                Section.history
            ]
        })
    }
    
}
