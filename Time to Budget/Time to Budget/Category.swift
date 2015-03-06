//
//  Category.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

public class Category: RLMObject {
    public dynamic var name = ""
    public dynamic var totalTimeRemaining = 0.0
    public dynamic var totalTimeBudgeted = 0.0
    public dynamic var tasks = RLMArray(objectClassName: Task.className())
    
    public func calcTime() {
        self.totalTimeRemaining = 0.0
        self.totalTimeBudgeted = 0.0
        
        for var i:UInt = 0; i < self.tasks.count; i++ {
            self.totalTimeRemaining += (self.tasks.objectAtIndex(i) as Task).timeRemaining
            self.totalTimeBudgeted += (self.tasks.objectAtIndex(i) as Task).timeBudgeted
        }
    }
}
