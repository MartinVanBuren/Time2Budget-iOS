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
    public dynamic var tasks = RLMArray(objectClassName: Task.className())
}
