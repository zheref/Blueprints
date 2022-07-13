import Foundation

protocol Day {
    var date: Date { get }
}

struct RedDay: Day, Equatable {
    let date: Date
}

struct BlueDay: Day, Equatable {
    let date: Date
    let blueprint: Blueprint
    let completion: DayCompletion?
    
    static func == (lhs: BlueDay, rhs: BlueDay) -> Bool {
        return lhs.date == rhs.date
    }
}
