//
//  Record.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

public class Record: RLMObject {
    public dynamic var date = NSDate(timeIntervalSince1970: 1)
    public dynamic var note = ""
    public dynamic var timeSpent = 0.0
}
