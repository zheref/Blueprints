import Foundation

struct WorkPlacement {
    let minutes: Int
    let environment: WorkEnvironment
    let mode: WorkMode
    let specifics: String?
    
    var hours: Double { Double(minutes) / 60 }
}

struct TrainingPlacement {
    let minutes: Int
    let environment: TrainingEnvironment
    let ways: [TrainingWay]
    let specifics: String?
    
    var hours: Double { Double(minutes) / 60 }
}

struct ChillPlacement {
    let minutes: Int
    let environment: ChillEnvironment
    let ways: [ChillWay]
    let specifics: String?
    
    var hours: Double { Double(minutes) / 60 }
}

enum BlueprintPrivacy {
    case privately
    case publicly
}

struct Blueprint: Equatable {
    let name: String
    
    let attribute: String
    let pictureUrl: String?
    
    let transport: TransportationMethod
    let system: SystemType
    
    let colors: [PrintColor]
    let music: MusicType
    let artists: [String]?
    
    let work: [WorkPlacement]
    
    let train: [TrainingPlacement]
    let chill: [ChillPlacement]
    
    let clothesStyles: [ClothesStyle]
    let notes: [String]
    
    var privacy: BlueprintPrivacy = .privately
    
    let documentID: String?
    let firePath: ZPath?
    
//    let music: CompletionStatus
//    let dressing: CompletionStatus
    
    func asPublic() -> Blueprint {
        var blueCopy = self
        blueCopy.privacy = .publicly
        return blueCopy
    }
    
    static func == (lhs: Blueprint, rhs: Blueprint) -> Bool {
        return lhs.name == rhs.name
    }
}
