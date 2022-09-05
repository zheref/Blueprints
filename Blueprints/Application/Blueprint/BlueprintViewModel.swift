import Foundation
import RxSwift

enum BlueprintViewEvent {
    case preparing
    case ready
}

typealias BlueRatios = (work: String, train: String, chill: String)

struct AspectModel: Equatable {
    enum Kind {
        case ratios
        case colors
        case simple
        case note
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
    case notes(aspects: [AspectModel])
    case history
    
    var title: String {
        switch self {
        case .blueprint(let attribute, _):
            return attribute
        case .work(aspects: _):
            return "👨🏻‍💻 Work Configuration"
        case .train(aspects: _):
            return "🏃‍♂️ Train Configuration"
        case .chill(aspects: _):
            return "🧖‍♂️ Chill Configuration"
        case .notes:
            return "📋 Notes"
        case .history:
            return "🗓 Some history"
        }
    }
}

class BlueprintViewModel: BlueViewModel {
    
    static func resolveGeneralAspects(forBlueprint bprint: Blueprint) -> [AspectModel] {
        var aspects = [AspectModel]()
        
        if let pictureUrl = bprint.pictureUrl {
            aspects.append(
                AspectModel(kind: .coverImage, key: "coverImage", caption: "Image", associatedValue: pictureUrl)
            )
        }
        
        let ratios: BlueRatios = (
            work: "\(bprint.workHours.asReadable(withDecimals: 0))h \(bprint.singleWorkEnvironmentDescription)",
            train: "\(bprint.trainHours.asReadable(withDecimals: 0))h \(bprint.singleTrainEnvironmentDescription)",
            chill: "\(bprint.chillHours.asReadable(withDecimals: 0))h \(bprint.singleChillEnvironmentDescription)"
        )
        aspects.append(AspectModel(
            kind: .ratios,
            key: "ratios",
            caption: "",
            associatedValue: ratios
        ))
        
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
            key: "transport",
            caption: "🛣 Transportation",
            associatedValue: bprint.transport.name)
        )
        
        aspects.append(AspectModel(
            kind: .simple,
            key: "clothes",
            caption: "👔 Clothes",
            associatedValue: bprint.clothesStyles
                .map { $0.rawValue.capitalized }
                .joined(separator: ", ")
        ))
        
        return aspects
    }
    
    static func resolveWorkAspects(forBlueprint bprint: Blueprint) -> [AspectModel] {
        var aspects = [AspectModel]()
        
        for (index, workPlacement) in bprint.work.enumerated() {
            aspects.append(AspectModel(
                kind: .simple,
                key: "workPlacement#\(index + 1)",
                caption: "\(workPlacement.mode.description.capitalized) #\(index + 1)",
                associatedValue: "\(workPlacement.mode.emoji) \(workPlacement.hours.asReadable(withDecimals: 0))h at \(workPlacement.environment.description)")
            )
        }
        
        return aspects
    }
    
    static func resolveTrainAspects(forBlueprint bprint: Blueprint) -> [AspectModel] {
        bprint.train.enumerated().map { (index, placement) in
            AspectModel(
                kind: .simple,
                key: "trainPlacement#\(index + 1)",
                caption: "\(placement.ways.map { $0.rawValue.capitalized }.joined(separator: ", "))",
                associatedValue: "\(placement.ways.first?.emoji ?? "") \(placement.hours.asReadable(withDecimals: 0))h at \(placement.environment.description)"
            )
        }
    }
    
    static func resolveChillAspects(forBlueprint bprint: Blueprint) -> [AspectModel] {
        bprint.chill.enumerated().map { (index, placement) in
            AspectModel(
                kind: .simple,
                key: "chillPlacement#\(index + 1)",
                caption: "\(placement.ways.map { $0.rawValue.capitalized }.joined(separator: ", "))",
                associatedValue: "\(placement.ways.first?.emoji ?? "") \(placement.hours.asReadable(withDecimals: 0))h at \(placement.environment.description)"
            )
        }
    }
    
    static func resolveNotesAspects(forBlueprint bprint: Blueprint) -> [AspectModel] {
        bprint.notes.enumerated().map { (index, note) in
            AspectModel(
                kind: .note,
                key: "note#\(index + 1)",
                caption: "",
                associatedValue: note
            )
        }
    }
    
    let event = PublishSubject<BlueprintViewEvent>()
    
    let blueprint: Observable<Blueprint>
    let sections: Observable<[BlueprintSection]>
    
    init(blueprint: Blueprint) {
        self.blueprint = Observable.of(blueprint)
        
        sections = self.blueprint.map({ bprint in
            let generalAspects = Self.resolveGeneralAspects(forBlueprint: bprint)
            let workAspects = Self.resolveWorkAspects(forBlueprint: bprint)
            let trainAspects = Self.resolveTrainAspects(forBlueprint: bprint)
            let chillAspects = Self.resolveChillAspects(forBlueprint: bprint)
            let notesAspects = Self.resolveNotesAspects(forBlueprint: bprint)
            
            return [
                BlueprintSection.blueprint(attribute: bprint.attribute, aspects: generalAspects),
                BlueprintSection.work(aspects: workAspects),
                BlueprintSection.train(aspects: trainAspects),
                BlueprintSection.chill(aspects: chillAspects),
                BlueprintSection.notes(aspects: notesAspects),
                BlueprintSection.history
            ]
        })
    }
    
}
