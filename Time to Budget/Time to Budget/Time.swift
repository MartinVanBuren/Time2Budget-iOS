//
//  Time.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

/**
Manages and formats time, in hours and minutes for Time to Budget.

The purpose of this class is to store and convert time, in the sense of hours and minutes, into all formats required
for this program. Some of such formats in String and Double. The current time is stored in the
hours and minutes integer variables. This class converts the time into a usable String for displaying
time and also into a Double for storage into the database.

Class Attributes:
+ hours: Int
+ minutes: Int

Class Methods:
- cleanTime()
- setByDouble(newTime: Double)
- toDouble()
- toString()
*/
public class Time {
    //============ Attributes ==========
    public var hours:Int = 0
    public var minutes:Int = 0
    public var isNegative:Bool = false
    
    
    //============ Constructors ============
    public init() {}
    public init(newTime: Double) {
        setByDouble(newTime)
    }
    public init(newHours: Int, newMinutes: Int) {
        self.hours = newHours
        self.minutes = newMinutes
    }
    
    /**
    Calculates time to constrain time to n hours and 0 <= n <= 60 minutes.
    
    This method will take the current values of self.hours and self.minutes and convert them into a proper format.
    For Example, 5h 70m will be converted into 6h 10m
    
    - Parameter None:
    - returns: Nothing
    */
    public func cleanTime() {
        
        if (self.hours >= 0) {
            while (self.minutes >= 60) {
                self.hours += 1
                self.minutes -= 60
            }

            while (self.minutes < 0) {
                self.hours -= 1
                self.minutes += 60
            }
        } else if (self.hours < 0) {
            while (self.minutes >= 60) {
                self.hours -= 1
                self.minutes -= 60
            }
            
            while (self.minutes < 0) {
                self.hours += 1
                self.minutes += 60
            }
        }
        
        if self.hours < 0 {
            self.isNegative = true
        } else if self.hours > 0 {
            self.isNegative = false
        }
    }
    
    /**
    Sets the current object to the time represented in a Double.
    
    This method uses a Double to set the current Time object equal to the Double's value.
    For Example: A Double of 5.45 will set self.hours = 5 and self.minutes = 45
    
    - Parameter newTime: Double to set time to.
    - returns: Nothing
    */
    public func setByDouble(newTime: Double) {
        var tempHrs:Double!
        var tempMins:Double!
        
        if newTime < 0 {
            tempHrs = ceil(atof(String(format: "%f", newTime)))
            tempMins = atof(String(format: "%f", newTime))
            tempMins = tempHrs - tempMins
        } else {
            tempHrs = floor(atof(String(format: "%f", newTime)))
            tempMins = atof(String(format: "%f", newTime))
            tempMins = tempMins - tempHrs
        }
        
        switch tempMins {
        case 0.25:
            tempMins = 15.0
        case 0.5:
            tempMins = 30.0
        case 0.75:
            tempMins = 45.0
        default:
            tempMins = 0.0
        }
        
        self.hours = Int(round(tempHrs))
        self.minutes = Int(round(tempMins))
        
        cleanTime()
        
        if newTime < 0 {
            self.isNegative = true
        }
    }
    
    /**
    Gets the Double value of the time from this object.
    
    This method converts self.hours and self.minutes into a Double format used to write to the Database.
    For Example: If self.hours = 5 and self.minutes = 45 this method will return a Double of 5.45
    
    - Parameter None:
    - returns: The Double value of the time stored in the object.
    */
    public func toDouble() -> Double {
        
        var tempMin:Double!
        
        switch self.minutes {
        case 15:
            tempMin = 0.25
        case 30:
            tempMin = 0.50
        case 45:
            tempMin = 0.75
        default:
            tempMin = 0
        }
        
        var finalDouble:Double!
        
        if self.isNegative {
            finalDouble = (Double(self.hours) - tempMin)
        } else {
            finalDouble = (Double(self.hours) + tempMin)
        }
        
        return (finalDouble)
    }
    
    /**
    Gets the String representation of the time stored in the object.
    
    This method converts self.hours and self.minutes into a String of the format "hh:mm"
    For Example: If self.hours = 5 and self.minutes = 45 the product String will be "5:45"
    
    - Parameter None:
    - returns: The String representation of the time stored in the object.
    */
    public func toString() -> String {
        self.cleanTime()
        
        if minutes == 0 && hours != 0 {
            return "\(hours):00"
        }
        else if minutes != 0 && hours == 0 {
            if self.isNegative {
                return "-00:\(minutes)"
            } else {
                return "00:\(minutes)"
            }
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
}