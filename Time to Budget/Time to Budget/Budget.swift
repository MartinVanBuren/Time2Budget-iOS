//
//  Budget.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

class Budget: RLMObject {
    dynamic var name = ""
    dynamic var categories = RLMArray(objectClassName: Category.className())
}