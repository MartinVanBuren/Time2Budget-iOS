//
//  Task.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

class Task: RLMObject {
    dynamic var name = ""
    dynamic var memo = ""
    dynamic var timeRemaining = 0.0
    dynamic var records = RLMArray(objectClassName: Record.className())
}
