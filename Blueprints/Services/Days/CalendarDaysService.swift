import Foundation

class CalendarDaysService: DaysServiceProtocol {
    
    func resolveAround(date: Date) -> Days {
        print("1. Resolving around for date: \(date.description)")
        var aroundDays = Days()
        aroundDays.append(contentsOf: resolveHistory(forDate: date, count: 1))
        aroundDays.append(resolve(todayFor: date))
        aroundDays.append(contentsOf: resolve(tomorrowFor: date, count: 5))
        return aroundDays
    }
    
    func resolveHistory(forDate date: Date, count: Int) -> Days {
        guard count > 0 else {
            return []
        }
        
        var days = Days()
        
        for dayIterator in 1...count {
            days.append(RedDay(
                date: Calendar.current.date(byAdding: .day, value: -dayIterator, to: date)!
            ))
        }
        
        return days.reversed()
    }
    
    func resolve(yesterdayFrom date: Date) -> Day {
        RedDay(date: Calendar.current.date(byAdding: .day, value: -1, to: date)!)
    }
    
    func resolve(todayFor date: Date) -> Day { RedDay(date: date) }
    
    func resolve(tomorrowFor date: Date, count: Int) -> Days {
        guard count > 0 else {
            return []
        }
        
        var days = Days()
        
        for dayIterator in 1...count {
            days.append(RedDay(
                date: Calendar.current.date(byAdding: .day, value: dayIterator, to: date)!
            ))
        }
        
        return days
    }
    
}
