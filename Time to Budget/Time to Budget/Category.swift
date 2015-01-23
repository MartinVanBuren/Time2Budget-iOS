//
//  Category.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

class Category: RLMObject {
    dynamic var name = ""
    dynamic var totalTimeRemaining = 0.0
    dynamic var tasks = RLMArray(objectClassName: Task.className())
}
