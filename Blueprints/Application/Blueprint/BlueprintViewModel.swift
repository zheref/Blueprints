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
    case blueprint(attribute: String, aspects: [AspectModel])
    case work(aspects: [AspectModel])
    case train(aspects: [AspectModel])
    case chill(aspects: [AspectModel])
    case notes
    case history
    
    var title: String {
        switch self {
        case .blueprint(let attribute, _):
            return attribute
        case .work(aspects: _):
            return "Work Configuration"
        case .train(aspects: _):
            return "Train Configuration"
        case .chill(aspects: _):
            return "Chill Configuration"
        case .notes:
            return "Notes"
        case .history:
            return "Some history"
        }
    }
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
                AspectModel(kind: .simple, key: "system", caption: "🧭 System", associatedValue: bprint.system.name)
            )
            
            var musicValue = ""
            if let artists = bprint.artists {
                musicValue = artists.joined(separator: ", ")
            } else {
                musicValue = bprint.music.name
            }
            
            aspects.append(
                AspectModel(kind: .simple, key: "music", caption: "🎵 Music", associatedValue: musicValue)
            )
            
            aspects.append(
                AspectModel(kind: .colors, key: "colors", caption: "🏳️‍🌈 Colors", associatedValue: bprint.colors)
            )
            
            aspects.append(AspectModel(
                kind: .simple,
                key: "clothes",
                caption: "👔 Clothes",
                associatedValue: bprint.clothesStyles
                    .map { $0.rawValue.capitalized }
                    .joined(separator: ", ")
            ))
            
            return [
                BlueprintSection.blueprint(attribute: bprint.attribute,aspects: aspects),
                BlueprintSection.history
            ]
        })
    }
    
}
