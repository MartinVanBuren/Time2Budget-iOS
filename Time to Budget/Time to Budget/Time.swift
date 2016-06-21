//
import UIKit

public class Time {
    //============ Attributes ==========
    public var hours: Int = 0
    public var minutes: Int = 0
    public var isNegative: Bool = false
    
    
    //============ Constructors ============
    public init() {}
    public init(newTime: Double) {
        set(newTime)
    }
    public init(newHours: Int, newMinutes: Int) {
        self.hours = newHours
        self.minutes = newMinutes
    }

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

    public func set(newTime: Double) {
        var tempHrs: Double!
        var tempMins: Double!
        
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

    public func toDouble() -> Double {
        
        var tempMin: Double!
        
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
        
        var finalDouble: Double!
        
        if self.isNegative {
            finalDouble = (Double(self.hours) - tempMin)
        } else {
            finalDouble = (Double(self.hours) + tempMin)
        }
        
        return (finalDouble)
    }
    
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
