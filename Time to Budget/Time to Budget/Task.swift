//
//  Task.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import RealmSwift

public class Task: Object {
    public dynamic var parent:Category!
    public dynamic var name = ""
    public dynamic var memo = ""
    public dynamic var timeBudgeted = 0.0
    public dynamic var totalTimeSpent = 0.0
    public dynamic var timeRemaining = 0.0
    public let records = List<Record>()
    
    public func calcTime() {
        self.totalTimeSpent = 0.0
        self.timeRemaining = 0.0
            
        for var i = 0; i < self.records.count; i++ {
            self.totalTimeSpent += self.records[i].timeSpent
        }
        
        self.timeRemaining = (self.timeBudgeted - self.totalTimeSpent)
        
        self.parent.calcTime()
    }
}
