import Foundation

extension Blueprint {
    
    var workHours: Double {
        work.reduce(0) { prev, work in
            prev + work.hours
        }
    }
    
    var trainHours: Double {
        train.reduce(0) { prev, train in
            prev + train.hours
        }
    }
    
    var chillHours: Double {
        chill.reduce(0) { prev, chill in
            prev + chill.hours
        }
    }
    
    var singleWorkEnvironmentDescription: String {
        guard !work.isEmpty else {
            return "nowhere"
        }
        
        if work.count > 1 {
            return Array(Set(work.map { $0.environment.emoji })).joined(separator: "")
        } else {
            return work[0].environment.description
        }
    }
    
    var singleTrainEnvironmentDescription: String {
        guard !train.isEmpty else {
            return "nowhere"
        }
        
        if train.count > 1 {
            return Array(Set(train.map { $0.environment.emoji })).joined(separator: "")
        } else {
            return train[0].environment.description
        }
    }
    
    var singleChillEnvironmentDescription: String {
        guard !chill.isEmpty else {
            return "nowhere"
        }
        
        if chill.count > 1 {
            return Array(Set(chill.map { $0.environment.emoji })).joined(separator: "")
        } else {
            return chill[0].environment.description
        }
    }
    
}
