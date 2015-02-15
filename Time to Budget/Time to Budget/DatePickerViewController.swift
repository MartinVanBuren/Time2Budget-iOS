//
//  DatePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var addRecordVC:AddRecordViewController!
    var datePicked:NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        addRecordVC.date = self.datePicked
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        datePicked = sender.date
    }
}
