//
//  Time.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit

class Time {
    var hours:Int = 0
    var minutes:Int = 0
    
    init() {}
    init(newHours: Int, newMinutes: Int) {
        self.hours = newHours
        self.minutes = newMinutes
    }
    init(budgetItem: BudgetItem) {
        let temp = floatToTime(budgetItem.timeRemaining)
        
        self.hours = temp.hours
        self.minutes = temp.minutes
    }
    init(itemRecord: ItemRecord) {
        let temp = floatToTime(itemRecord.timeSpent)
        
        self.hours = temp.hours
        self.minutes = temp.minutes

    }
    init(categoryItem: CategoryItem) {
        let temp = floatToTime(categoryItem.totalTimeRemaining)
        
        self.hours = temp.hours
        self.minutes = temp.minutes

    }
    
    // Methods
    
    func cleanTime() {
        var newHrs:Int = self.hours
        var newMins:Int = self.minutes
        
        while newMins >= 60 {
            newHrs += 1
            newMins -= 60
        }
        
        self.hours = newHrs
        self.minutes = newMins
    }
    
    class func cleanTime(#newHrs: Int, newMins: Int) -> Time {
        var finalTime:Time = Time(newHours: newHrs, newMinutes: newMins)
        
        while finalTime.minutes >= 60 {
            finalTime.hours += 1
            finalTime.minutes -= 60
        }
        
        return finalTime
    }
    
    func setByFloat(newTime: Float) {
        var tempTime:Time = floatToTime(newTime)
        
        self.hours = tempTime.hours
        self.minutes = tempTime.minutes
    }
    
    // Conversion Methods
    
    func toFloat() -> Float {
        return Float(self.hours) + Float(Float(self.minutes) / 100.0)
    }
    
    func floatToTime(newTime: Float) -> Time {
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
        
        return Time(newHours: tempHours, newMinutes: tempMins)
    }
    
    func toString() -> String {
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
    
    class func floatToString(time: Float) -> String {
        var finalTime:Time = floatToTime(time)
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
    
    class func floatToTime(newTime: Float) -> Time {
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
        
        return Time(newHours: tempHours, newMinutes: tempMins)
    }
}