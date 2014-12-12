//
//  CategoryItem.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(CategoryItem)
class CategoryItem: NSManagedObject {
    @NSManaged var name:String
    @NSManaged var timeMinsRemain:NSNumber
    @NSManaged var timeHrsRemain:NSNumber
}
