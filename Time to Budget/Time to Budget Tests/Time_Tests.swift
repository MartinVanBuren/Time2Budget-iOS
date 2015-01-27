//
//  Time_Tests.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/24/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import XCTest
import Time_to_Budget

class Time_Tests: XCTestCase {
    var time: Time = Time()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        time = Time()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_cleanTime() {
        
        time.hours = 5
        time.minutes = 75
        time.cleanTime()
        
        time.minutes = -135
        time.cleanTime()
        
        let results = (time.hours == 3 && time.minutes == 45)
        
        XCTAssert(results, "Failed to Clean Time")
    }
    
    func test_cleanTimeNegative() {
        
        time.hours = -6
        time.minutes = 60
        time.cleanTime()
        
        time.minutes = -45
        time.cleanTime()
        
        let results = (time.hours == -6 && time.minutes == 15)
        
        XCTAssert(results, "Failed to Clean Negative Time")
    }

    func test_setByDouble() {
        
        time.setByDouble(5.75)
        
        XCTAssert((time.hours == 6 && time.minutes == 15), "Failed to Set Value from a Double")
    }
    
    func test_toDouble() {
        
        time.hours = 5
        time.minutes = 15
        
        XCTAssert((time.toDouble() == 5.15), "Failed to Convert to Double")
    }
    
    func test_toString() {
        
        time.hours = 5
        time.minutes = 0
        
        XCTAssert((time.toString() == "5:00"), "Failed to Convert to String")
        
    }
    
    func test_doubleToString() {
        
        XCTAssert((Time.doubleToString(4.30) == "4:30"), "Failed to Convert Double to String")
        
    }
    
    func test_doubleToTime() {
        
        time = Time.doubleToTime(6.15)
        
        XCTAssert((time.hours == 6 && time.minutes == 15), "Failed to Convert Double to Time")
    }
}
