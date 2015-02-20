//
//  Task.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/11/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

public class Task: RLMObject {
    public dynamic var parent:Category!
    public dynamic var name = ""
    public dynamic var memo = ""
    public dynamic var timeRemaining = 0.0
    public dynamic var records = RLMArray(objectClassName: Record.className())
}
