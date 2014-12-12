//
//  BudgetItem.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(BudgetItem)
class BudgetItem: NSManagedObject {
    @NSManaged var isVisible:NSNumber
    @NSManaged var descript:String
    @NSManaged var name:String
    @NSManaged var timeHrsRemain:NSNumber
    @NSManaged var timeMinsRemain:NSNumber
    @NSManaged var category:String
    
    func remaingTimeAsString() -> String {
        return "\(timeHrsRemain):\(timeMinsRemain)"
    }
}
