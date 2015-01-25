//
//  Budget.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import Realm

public class Budget: RLMObject {
    public dynamic var name = ""
    public dynamic var categories = RLMArray(objectClassName: Category.className())
}