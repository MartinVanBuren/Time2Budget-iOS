//
//  Record.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

class Record: RLMObject {
    dynamic var id = 0
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var note = ""
    dynamic var timeSpent = 0.0
}
