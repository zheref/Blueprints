import Foundation

struct BlueDate: Equatable {
    let day: Int
    let month: Int
    let year: Int
    
    static func from(date: Date) -> BlueDate {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Self.from(string: formatter.string(from: date))!
    }
    
    static func from(string: String) -> BlueDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: string) else {
            return nil
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let day = components.day, let month = components.month, let year = components.year else {
            return nil
        }
        
        return BlueDate(day: day, month: month, year: year)
    }
    
    static var today: BlueDate {
        BlueDate.from(date: Date())
    }
    
    var isToday: Bool {
        return self == Self.today
    }
    
    func toString() -> String? {
        guard let date = toDate() else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    static func == (lhs: BlueDate, rhs: BlueDate) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }
    
    func toDate() -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        
        return Calendar(identifier: .gregorian)
            .date(from: components)
    }
}

protocol Day {
    var date: BlueDate { get }
}

struct RedDay: Day, Equatable {
    let date: BlueDate
    
    static func == (lhs: RedDay, rhs: RedDay) -> Bool {
        return lhs.date == rhs.date
    }
}

struct BlueDay: Day, Equatable {
    let date: BlueDate
    let blueprint: Blueprint
    let completion: DayCompletion?
    
    static func from(red: RedDay, withPrint blueprint: Blueprint) -> BlueDay {
        return BlueDay(date: red.date, blueprint: blueprint, completion: nil)
    }
    
    static func == (lhs: BlueDay, rhs: BlueDay) -> Bool {
        return lhs.date == rhs.date
    }
}
