//
//  Clock.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/10/15.
//  Copyright © 2015 Arrken Software, LLC. All rights reserved.
//

import Foundation
import UIKit

class Clock {
    internal var clockedIn:Bool = false
    private var startTime:NSTimeInterval!
    private var timer = NSTimer()
    private var finalTime = Time()
    
    internal func clockInOut() -> Bool {
        if self.clockedIn {
            self.clockedIn = false
            self.timer.invalidate()
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            
            var elapsedTime = currentTime - self.startTime
            
            let hours = UInt8((elapsedTime / 60.0) / 60.0)
            elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
            
            let minutes = UInt8(round((elapsedTime / 60.0) / 15) * 15)
            elapsedTime -= (NSTimeInterval(minutes) * 60)
            
            let seconds = UInt8(elapsedTime)
            elapsedTime -= (NSTimeInterval(seconds))
            
            self.finalTime.hours = Int(hours)
            self.finalTime.minutes = Int(minutes)
            return true
        } else {
            self.clockedIn = true
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            return false
        }
    }
    
    internal func getTime() -> Time {
        if clockedIn {
            return Time()
        } else {
            return self.finalTime
        }
    }
}
