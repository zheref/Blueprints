//
//  CalendarDaysServiceTests.swift
//  BlueprintsTests
//
//  Created by Sergio Lozano on 17/07/22.
//

import XCTest
@testable import Blueprints

class CalendarDaysServiceTests: XCTestCase {
    
    var daysService: DaysServiceProtocol!

    override func setUpWithError() throws {
        daysService = CalendarDaysService()
    }

    override func tearDownWithError() throws {
        daysService = nil
    }

    func testResolveHistory() {
        guard let today = Date.withComponents(day: 17, month: 7, year: 2022) else {
            XCTFail("Today is not a valid date")
            return
        }
        
        let count = 3
        
        let expectedDates = [
            BlueDate.from(date: Date.withComponents(day: 14, month: 7, year: 2022)!),
            BlueDate(day: 15, month: 7, year: 2022),
            BlueDate.from(date: Date.withComponents(day: 16, month: 7, year: 2022)!)
        ]
        
        let actualDays = daysService.resolveHistory(forDate: today, count: count)
        
        XCTAssertEqual(actualDays.count, count)
        XCTAssertEqual(actualDays.map { $0.date }, expectedDates)
    }
    
    func testResolveYesterday() {
        guard let today = Date.withComponents(day: 17, month: 7, year: 2022) else {
            XCTFail("Today is not a valid date")
            return
        }
        
        XCTAssertEqual(
            daysService.resolve(yesterdayFrom: today).date,
            BlueDate.from(date: Date.withComponents(day: 16, month: 7, year: 2022)!)
        )
    }
    
    func testResolveToday() {
        guard let today = Date.withComponents(day: 17, month: 7, year: 2022) else {
            XCTFail("Today is not a valid date")
            return
        }
        
        XCTAssertEqual(daysService.resolve(todayFor: today).date, BlueDate.from(date: today))
    }
    
    func testResolveTomorrow() {
        guard let today = Date.withComponents(day: 17, month: 7, year: 2022) else {
            XCTFail("Today is not a valid date")
            return
        }
        
        let count = 3
        
        let expectedDates = [
            Date.withComponents(day: 18, month: 7, year: 2022)!,
            Date.withComponents(day: 19, month: 7, year: 2022)!,
            Date.withComponents(day: 20, month: 7, year: 2022)!
        ].map { BlueDate.from(date: $0) }
        
        let actualDays = daysService.resolve(tomorrowFor: today, count: count)
        
        XCTAssertEqual(actualDays.count, count)
        XCTAssertEqual(actualDays.map { $0.date }, expectedDates)
    }

}
