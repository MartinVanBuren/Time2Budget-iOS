//
//  Clock.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/10/15.
//  Copyright © 2015 Arrken Software, LLC. All rights reserved.
//

import Foundation
import RealmSwift

public class Clock: Object {
    //==================== Properties ====================
    public dynamic var clockedIn:Bool = false
    public dynamic var startTime:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    public dynamic var finalTime:Double = 0.0
    
    //==================== Methods ====================
    internal func clockInOut() {
        if self.clockedIn {
            self.clockedIn = false
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime = currentTime - self.startTime
            
            // Retrieve hours from elapsedTime
            let hours = Int((elapsedTime / 60.0) / 60.0)
            elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
            
            // Retrieve minutes from elapsedTime
            let rawMinutes = Int(round((elapsedTime / 60.0) / 15) * 15)
            elapsedTime -= (NSTimeInterval(rawMinutes) * 60)
            
            // Retrieve seconds from elapsedTime
            let seconds = Int(elapsedTime)
            elapsedTime -= (NSTimeInterval(seconds))
            
            var minutes = 0.0
            
            switch(rawMinutes){
            case 15:
                minutes = 0.25
            case 30:
                minutes = 0.5
            case 45:
                minutes = 0.75
            default:
                minutes = 0.0
            }
            
            self.finalTime = (Double(hours) + minutes)
        } else {
            self.clockedIn = true
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
}
