//
//  Budget.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

public class Budget: RLMObject {
    public dynamic var startDate = NSDate()
    public dynamic var endDate = NSDate()
    public dynamic var name = ""
    public dynamic var isCurrent = false
    public dynamic var categories = RLMArray(objectClassName: Category.className())
    
    public func autoInit() {
        let dt = NSDate()
        let cal = NSCalendar.currentCalendar()
        let dc = cal.components(NSCalendarUnit.WeekdayCalendarUnit|NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit, fromDate: dt)
        let normDt = cal.dateFromComponents(dc)
        let shift = dc.weekday - cal.firstWeekday
        
        self.startDate = normDt!.dateByAddingTimeInterval(daySec(shift*(0-1)))
        self.endDate = normDt!.dateByAddingTimeInterval(daySec((shift*(0-1))+7))
        self.name = "\(dateToString(startDate)) - \(dateToString(endDate))"
        self.isCurrent = true
    }
    
    public func checkPassedEndDate() -> Bool {
        let cal = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let endingDate = endDate
        let dif = cal.compareDate(currentDate, toDate: endingDate, toUnitGranularity: NSCalendarUnit.SecondCalendarUnit)
        
        if dif == NSComparisonResult.OrderedAscending
        {
            return false
        }
        else if dif == NSComparisonResult.OrderedDescending
        {
            return true
        }
        else
        {
            return true
        }
    }
    
    private func dateToString(dt: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yy"
        
        return dateFormatter.stringFromDate(dt)
    }
    
    private func daySec(diff: Int) -> NSTimeInterval { return NSTimeInterval(60*60*24*diff) }
}