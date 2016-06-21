import XCTest
@testable import Time_to_Budget

class Time_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_cleanTime() {
        let time = Time()
        
        time.hours = 5
        time.minutes = 75
        time.cleanTime()
        
        time.minutes = -135
        time.cleanTime()
        
        let results = (time.hours == 3 && time.minutes == 45)
        
        XCTAssert(results, "Failed to Clean Time")
    }
    
    func test_cleanTimeNegative() {
        let time = Time()
        
        time.hours = -6
        time.minutes = 60
        time.cleanTime()
        
        time.minutes = -45
        time.cleanTime()
        
        let results = (time.hours == -6 && time.minutes == 15)
        
        XCTAssert(results, "Failed to Clean Negative Time")
    }

    func test_setByDouble() {
        let time = Time()
        
        time.setByDouble(3.75)
        
        XCTAssert((time.hours == 3 && time.minutes == 45), "Failed to Set Value from a Double")
    }
    
    func test_toDouble() {
        
        var time = Time()
        time.hours = 5
        time.minutes = 15
        time.cleanTime()
        
        var testTime = time.toDouble()
        
        let posTest = (testTime == 5.25)
        
        time = Time()
        time.hours = -6
        time.minutes = 30
        time.cleanTime()
        
        testTime = time.toDouble()
        
        let negTest = (testTime == -6.5)
        
        time = Time()
        time.hours = 7
        time.minutes = 45
        time.cleanTime()
        
        testTime = time.toDouble()
        
        let otherTest = (testTime == 7.75)
        
        time = Time()
        time.hours = 0
        time.minutes = 15
        time.cleanTime()
        
        testTime = time.toDouble()
        
        let zeroTest = (testTime == 0.25)
        
        XCTAssert((posTest && negTest && otherTest && zeroTest), "Failed to Convert to Double")
    }
    
    func test_toString() {
        let time = Time()
        
        time.hours = 5
        time.minutes = 0
        
        let zeroMinTest = (time.toString() == "5:00")
        
        time.hours = 0
        time.minutes = 30
        
        let zeroHrTest = (time.toString() == "00:30")
        
        time.hours = 2
        time.minutes = 15
        
        let noZeroTest = (time.toString() == "2:15")
        
        time.hours = -2
        time.minutes = 15
        
        let negTest = (time.toString() == "-2:15")
        
        XCTAssert((zeroMinTest && zeroHrTest && noZeroTest && negTest), "Failed to Convert to String")
        
    }
    
    func test_doubleToString() {
        
        let neg = Time(newTime: -5.25).toString()
        let pos = Time(newTime: 4.50).toString()
        let other = Time(newTime: 3.75).toString()
        let zero = Time(newTime: 6.0).toString()
        
        let negTest = (neg == "-5:15")
        let posTest = (pos == "4:30")
        let otherTest = (other == "3:45")
        let zeroTest = (zero == "6:00")
        
        XCTAssert((negTest && posTest && otherTest && zeroTest), "Failed to Convert Double to String")
        
    }
    
    func test_doubleToTime() {
        var time = Time()
        
        time = Time(newTime: 6.25)
        
        XCTAssert((time.hours == 6 && time.minutes == 15), "Failed to Convert Double to Time")
    }
    
}
