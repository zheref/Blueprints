import Foundation

class DayViewModel {
    let day: Day
    
    var baseDay: RedDay { day as? RedDay ?? RedDay(date: day.date) }
    var assignedDay: BlueDay? { day as? BlueDay }
    
    var actualDayTitle: String {
        let today = Date()
        
        if day.date.sameDay(as: today) {
            return K.Copy.today
        } else if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today),
                    day.date == yesterday {
            return K.Copy.yesterday
        }
        
        return day.date.weekday
    }
    
    var blueprintDayTitle: String {
        guard let blueprint = assignedDay?.blueprint else {
            return K.Copy.unassigned
        }
        
        return blueprint.name
    }
    
    var dayNumber: String {
        return "\(Calendar.current.component(.day, from: day.date))"
    }
    
    var hightlightColor: String {
        if day.date.sameDay(as: Date()) {
            return K.Color.greenDay
        }
        
        if let _ = assignedDay {
            return K.Color.blueDay
        } else {
            return K.Color.redDay
        }
    }
    
    init(day: Day) {
        self.day = day
    }
}
