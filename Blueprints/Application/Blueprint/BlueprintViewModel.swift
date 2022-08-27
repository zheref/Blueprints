import Foundation
import RxSwift

enum BlueprintViewEvent {
    case preparing
    case ready
}

struct AspectModel: Equatable {
    enum Kind {
        case colors
        case simple
        case coverImage
    }
    
    let kind: Kind
    let key: String
    let caption: String
    let associatedValue: Any
    
    static func == (lhs: AspectModel, rhs: AspectModel) -> Bool {
        return lhs.kind == rhs.kind
            && lhs.caption == rhs.caption
            && lhs.key == rhs.key
    }
}

enum BlueprintSection {
    case blueprint(aspects: [AspectModel])
    case history
}

class BlueprintViewModel: BlueViewModel {
    
    let event = PublishSubject<BlueprintViewEvent>()
    
    let blueprint: Observable<Blueprint>
    let sections: Observable<[BlueprintSection]>
    
    init(blueprint: Blueprint) {
        self.blueprint = Observable.of(blueprint)
        
        sections = self.blueprint.map({ bprint in
            var aspects = [AspectModel]()
            
            if let pictureUrl = bprint.pictureUrl {
                aspects.append(
                    AspectModel(kind: .coverImage, key: "coverImage", caption: "Image", associatedValue: pictureUrl)
                )
            }
            
            aspects.append(
                AspectModel(kind: .simple, key: "system", caption: "System", associatedValue: bprint.system.name)
            )
            
            aspects.append(
                AspectModel(kind: .colors, key: "colors", caption: "Colors", associatedValue: bprint.colors)
            )
            
            return [
                BlueprintSection.blueprint(aspects: aspects),
                BlueprintSection.history
            ]
        })
    }
    
}
