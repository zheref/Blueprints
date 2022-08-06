import Foundation

class DayViewModel {
    let day: Day
    
    var baseDay: RedDay { day as? RedDay ?? RedDay(date: day.date) }
    var assignedDay: BlueDay? { day as? BlueDay }
    
    var actualDayTitle: String {
        let today = BlueDate.from(date: Date())
        
        if day.date.day == today.day {
            return K.Copy.today
        } else if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today.toDate()!),
                  day.date.toDate()! == yesterday {
            return K.Copy.yesterday
        }
        
        return day.date.toDate()!.weekday
    }
    
    var blueprintDayTitle: String {
        guard let blueprint = assignedDay?.blueprint else {
            return K.Copy.unassigned
        }
        
        return blueprint.name
    }
    
    var dayNumber: String {
        return "\(Calendar.current.component(.day, from: day.date.toDate()!))"
    }
    
    var hightlightColor: String {
        if day.date.day == BlueDate.today.day {
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
