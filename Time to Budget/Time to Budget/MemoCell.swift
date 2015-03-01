//
//  MemoCell.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/15/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var memoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
