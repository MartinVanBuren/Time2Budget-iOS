//
//  NewCategoryView.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 11/26/15.
//  Copyright © 2015 Arrken Software, LLC. All rights reserved.
//

import UIKit

class NewCategoryView: UITableViewHeaderFooterView {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var remainingTimeBar: UIView!
    @IBOutlet weak var remainingTimeBarOutline: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    var category:Category?

}