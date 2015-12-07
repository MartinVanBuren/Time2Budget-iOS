//
//  CategoryCell.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var remainingTimeBar: UIView!
    @IBOutlet weak var remainingTimeBarOutline: UIView!
    var category: Category?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
