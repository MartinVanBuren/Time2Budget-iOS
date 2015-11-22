//
//  CategoryView.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 10/31/15.
//  Copyright © 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class CategoryView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var customContentView: UIView!
    internal var VC: BudgetEditorViewController?
    
    
    @IBAction func editCategoryButtonPressed(sender: UIButton) {
        Factory.displayEditCategoryAlert(viewController: self.VC!, categoryName: self.sectionNameLabel.text!)
    }
}
