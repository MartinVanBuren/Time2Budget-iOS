//
//  ItemRecord.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(ItemRecord)
class ItemRecord: NSManagedObject {
    @NSManaged var date:NSDate
    @NSManaged var note:String
    @NSManaged var timeHrsSpent:NSNumber
    @NSManaged var timeMinsSpent:NSNumber
}
