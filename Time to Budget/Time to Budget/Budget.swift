import Foundation
import RealmSwift

public class Budget: Object {

    public dynamic var startDate = NSDate()
    public dynamic var endDate = NSDate()
    public dynamic var name = ""
    public dynamic var isCurrent = false
    public let categories = List<Category>()
    public dynamic var clock: Clock? = Clock()
    
    public func autoInit() {
        let dt = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dc = calendar.components([NSCalendarUnit.Weekday, NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: dt)
        let normDt = calendar.dateFromComponents(dc)
        let shift = dc.weekday - calendar.firstWeekday
        
        startDate = normDt!.dateByAddingTimeInterval(daySec(shift*(0-1)))
        endDate = normDt!.dateByAddingTimeInterval(daySec((shift*(0-1))+7))
        // Remove 1 day from the endDate.
        let endDateStr = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: endDate, options: [])
        name = "\(dateToString(startDate)) - \(dateToString(endDateStr!))"
        isCurrent = true
    }
    
    public func checkPassedEndDate() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let endingDate = endDate
        let dif = calendar.compareDate(currentDate, toDate: endingDate, toUnitGranularity: NSCalendarUnit.Second)
        
        if dif == NSComparisonResult.OrderedAscending {
            return false
        }
        else if dif == NSComparisonResult.OrderedDescending {
            return true
        }
        else {
            return true
        }
    }
    
    private func dateToString(dt: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yy"
        return dateFormatter.stringFromDate(dt)
    }
    
    private func daySec(diff: Int) -> NSTimeInterval {
        return NSTimeInterval(60*60*24*diff)
    }
    
}
