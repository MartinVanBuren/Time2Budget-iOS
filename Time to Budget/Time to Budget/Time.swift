//
//  Time.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit

/*
**    Class Purpose:
**    This class stores and converts time, in the sense of hours and minutes, into all formats required 
**    for this program. Some of such formats in String and Double. The current time is stored in the 
**    hours and minutes integer variables. This class converts the time into a usable String for displaying
**    time and also into a Double for storage into the database.
**
**    Class Attributes:
**    + hours: Int
**    + minutes: Int
**
**    Class Methods:
**    - cleanTime()
**    - setByDouble(newTime: Double)
**    - toDouble()
**    - toString()

**    Class Static Methods:
**    - doubleToString(time: Double)
**    - doubleToTime(newTime: Double)
*/
public class Time {
    //============ Attributes ==========
    public var hours:Int = 0
    public var minutes:Int = 0
    
    
    //============ Constructors ============
    public init() {}
    public init(newHours: Int, newMinutes: Int) {
        self.hours = newHours
        self.minutes = newMinutes
    }


    //============================= Methods =============================
    /*
    **    Method Purpose:
    **    This method will take the current values of self.hours and self.minutes and convert them into a proper format. 
    **    For Example: 5h 70m will be converted into 6h 10m
    **    
    **    Parameters:
    **    None
    **    
    **    Returns:
    **    None
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
    }


    /*
    **    Method Purpose:
    **    Uses a Double pulled from a database object to set the current Time object equal to the Double's value.
    **    For Example: A Double of 5.45 will set self.hours = 5 and self.minutes = 45
    **    
    **    Parameters:
    **    Double: Pulled from a database object.
    **    
    **    Returns:
    **    None
    */
    public func setByDouble(newTime: Double) {
        var tempTime:Time = Time.doubleToTime(newTime)
        
        tempTime.cleanTime()
        
        self.hours = tempTime.hours
        self.minutes = tempTime.minutes
    }
    

    /*
    **    Method Purpose:
    **    Converts self.hours and self.minutes into a Double format used to write to the Database.
    **    For Example: If self.hours = 5 and self.minutes = 45 this method will return a Double of 5.45
    **    
    **    Parameters:
    **    None
    **    
    **    Returns:
    **    Double: Value converted from self.hours and self.minutes
    */
    public func toDouble() -> Double {
        return Double(self.hours) + Double(Double(self.minutes) / 100.0)
    }
    

    /*
    **    Method Purpose:
    **    Converts self.hours and self.minutes into a String of the format "hh:mm"
    **    For Example: If self.hours = 5 and self.minutes = 45 the product String will be "5:45"
    **    
    **    Parameters:
    **    None
    **    
    **    Returns:
    **    String: Value converted from self.hours and self.minutes
    */
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
    

    //======================== Static Methods ========================
    /*
    **    Method Purpose:
    **    Converts the Double representation of Time from a database object into a String much like the toString() method.
    **    For Example: A Double of 5.45 will be converted into a String "5:45"
    **    
    **    Parameters:
    **    Double: Pulled from a database object
    **    
    **    Returns:
    **    String: Value of Double as a String
    */
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
    

    /*
    **    Method Purpose:
    **    Creates a new Time object initialized with the value of a Double pulled from a database object.
    **    For Example: A Double of 5.45 will return a Time object where Time.hours = 5 and Time.minutes = 45
    **    
    **    Parameters:
    **    Double: Pulled from a database object
    **    
    **    Returns:
    **    Time: A Time instance containing the Time value of the Double parameter
    */
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