//
//  MemoTextfieldCell.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 11/22/15.
//  Copyright © 2015 Arrken Software, LLC. All rights reserved.
//

import UIKit

class MemoTextfieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
