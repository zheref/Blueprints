import Foundation

extension Date {
    
    var weekday: String {
        DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
    }
    
    func sameDay(as date: Date) -> Bool {
        Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: date)
    }
    
    static func withComponents(day: Int, month: Int, year: Int) -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        
        return Calendar(identifier: .gregorian)
            .date(from: components)
    }
    
    static var dayUnit: TimeInterval = {
        return TimeInterval(60 * 60 * 24)
    }()
}
