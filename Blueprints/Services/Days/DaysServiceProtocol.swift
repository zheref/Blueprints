import Foundation

typealias Days = [Day]

protocol DaysServiceProtocol {
    func resolveAround(date: Date) -> Days
    func resolveHistory(forDate date: Date, count: Int) -> Days
    func resolve(yesterdayFrom date: Date) -> Day
    func resolve(todayFor date: Date) -> Day
    func resolve(tomorrowFor date: Date, count: Int) -> Days
}
