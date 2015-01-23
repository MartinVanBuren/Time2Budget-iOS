//
//  TimeTestCase.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import XCTest
import Realm
import Time_to_Budget

class TimeTestCase: XCTestCase {
    var timeTest = Time()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        timeTest = Time()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        timeTest = Time()
        super.tearDown()
    }
    
    func floatToTimeTest() {
        
        var passed = false
        let test = timeTest.doubleToTime(5.30)
        if (test.hours == 5) {
            if (test.minutes == 30) {
                passed = true
            }
        }
        
        XCTAssert(passed, "Pass")
    }
    
    func toStringTest() {
        timeTest.hours = 8
        timeTest.minutes = 00
        var passed = false
        
        if (timeTest.toString() == "8:00") {
            passed = true
        }
        
        XCTAssert(passed, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}