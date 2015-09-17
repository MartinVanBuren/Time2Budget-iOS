//
//  Category.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import RealmSwift

public class Category: Object {
    public dynamic var name = ""
    public dynamic var totalTimeRemaining = 0.0
    public dynamic var totalTimeBudgeted = 0.0
    public dynamic var parent: Budget!
    public let tasks = List<Task>()
    
    public func calcTime() {
        self.totalTimeRemaining = 0.0
        self.totalTimeBudgeted = 0.0
        
        for var i = 0; i < self.tasks.count; i++ {
            self.totalTimeRemaining += self.tasks[i].timeRemaining
            self.totalTimeBudgeted += self.tasks[i].timeBudgeted
        }
    }
}
