//
//  Time.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit

public class Time {
    public var hours:Int = 0
    public var minutes:Int = 0
    
    public init() {}
    public init(newHours: Int, newMinutes: Int) {
        self.hours = newHours
        self.minutes = newMinutes
    }
    public init(task: Task) {
        let temp = Time.doubleToTime(task.timeRemaining)
        
        self.hours = temp.hours
        self.minutes = temp.minutes
    }
    public init(record: Record) {
        let temp = Time.doubleToTime(record.timeSpent)
        
        self.hours = temp.hours
        self.minutes = temp.minutes

    }
    public init(category: Category) {
        let temp = Time.doubleToTime(category.totalTimeRemaining)
        
        self.hours = temp.hours
        self.minutes = temp.minutes

    }
    
    // Methods
    
    public func cleanTime() {
        while self.minutes >= 60 {
            self.hours += 1
            self.minutes -= 60
        }

        while self.minutes < 0 {
            self.hours -= 1
            self.minutes += 60
        }
    }
    
    public func setByDouble(newTime: Double) {
        var tempTime:Time = Time.doubleToTime(newTime)
        
        tempTime.cleanTime()
        
        self.hours = tempTime.hours
        self.minutes = tempTime.minutes
    }
    
    // Conversion Methods
    
    public func toDouble() -> Double {
        return Double(self.hours) + Double(Double(self.minutes) / 100.0)
    }
    
    public func toString() -> String {
        self.cleanTime()
        
        if minutes == 0 && hours != 0 {
            return "\(hours):00"
        }
        else if minutes != 0 && hours == 0 {
            return "00:\(minutes)"
        }
        else if minutes == 0 && hours == 0 {
            return "00:00"
        }
        else if minutes != 0 && hours != 0 {
            return "\(hours):\(minutes)"
        }
        else {
            return "Error in Time String Conversion!"
        }
        
    }
    
    // Conversion Class Methods
    
    public class func doubleToString(time: Double) -> String {
        var finalTime:Time = doubleToTime(time)
        finalTime.cleanTime()
        
        if finalTime.minutes == 0 && finalTime.hours != 0 {
            return "\(finalTime.hours):00"
        }
        else if finalTime.minutes != 0 && finalTime.hours == 0 {
            return "00:\(finalTime.minutes)"
        }
        else if finalTime.minutes == 0 && finalTime.hours == 0 {
            return "00:00"
        }
        else if finalTime.minutes != 0 && finalTime.hours != 0 {
            return "\(finalTime.hours):\(finalTime.minutes)"
        }
        else {
            return "Error in Time String Conversion!"
        }
    }
    
    public class func doubleToTime(newTime: Double) -> Time {
        let arrayString = Array(String("\(newTime)"))
        var passDecimal:Bool = false
        
        var digitHrs = Array("")
        var digitMins = Array("")
        
        for var i = 0; i < arrayString.count; i++ {
            if arrayString[i] != "." && passDecimal == false {
                digitHrs.append(arrayString[i])
            } else if arrayString[i] != "." && passDecimal == true {
                digitMins.append(arrayString[i])
            } else if arrayString[i] == "." {
                passDecimal = true
            }
        }
        
        var tempHours = String(digitHrs).toInt()!
        var tempMins = String(digitMins).toInt()!
        
        if tempMins == 3 {
            tempMins *= 10
        }
        
        let finalTime = Time(newHours: tempHours, newMinutes: tempMins)
        finalTime.cleanTime()
        
        return finalTime
    }
}