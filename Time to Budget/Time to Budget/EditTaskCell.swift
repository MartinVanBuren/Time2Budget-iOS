//
//  EditTaskCell.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/13/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

class EditTaskCell: UITableViewCell {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var hrsTextField: UITextField!
    @IBOutlet weak var minsTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
