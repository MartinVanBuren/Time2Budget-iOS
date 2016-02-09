//
//  Budget.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import RealmSwift

public class Budget: Object {
    //==================== Properties ====================
    public dynamic var startDate = NSDate()
    public dynamic var endDate = NSDate()
    public dynamic var name = ""
    public dynamic var isCurrent = false
    public let categories = List<Category>()
    public dynamic var clock:Clock? = Clock()
    
    //==================== Methods ====================
    public func autoInit() {
        // Retrieve information needed to calculate the current budget information
        let dt = NSDate()
        let cal = NSCalendar.currentCalendar()
        let dc = cal.components([NSCalendarUnit.Weekday, NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: dt)
        let normDt = cal.dateFromComponents(dc)
        let shift = dc.weekday - cal.firstWeekday
        
        // Calculate and set startDate and endDate.
        self.startDate = normDt!.dateByAddingTimeInterval(daySec(shift*(0-1)))
        self.endDate = normDt!.dateByAddingTimeInterval(daySec((shift*(0-1))+7))
        // Remove 1 day from the endDate in order to generate an accurate name running from Sunday-Saturday.
        let calendar = NSCalendar.currentCalendar()
        let endDateStr = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: endDate, options: [])
        self.name = "\(dateToString(startDate)) - \(dateToString(endDateStr!))"
        self.isCurrent = true
    }
    
    public func checkPassedEndDate() -> Bool {
        // Retrieve the currentDate and compare it to the endDate to see if the budget lifetime has ended.
        let cal = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let endingDate = endDate
        let dif = cal.compareDate(currentDate, toDate: endingDate, toUnitGranularity: NSCalendarUnit.Second)
        
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yy"
        return dateFormatter.stringFromDate(dt)
    }
    
    private func daySec(diff: Int) -> NSTimeInterval { return NSTimeInterval(60*60*24*diff) }
}