//
//  Task.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {
    @NSManaged var isVisible:Bool
    @NSManaged var descript:String
    @NSManaged var name:String
    @NSManaged var timeRemaining:Float
    @NSManaged var category:String
}
