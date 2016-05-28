//
//  RecordCell.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/28/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class SubtitleDetailCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var customContentView: UIView!
    var task: Task?
    var editor: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
