//
//  DatePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class RecordEditorDatePickerViewController: UIViewController {

    var recordEditorVC:RecordEditorViewController!
    var datePicked:NSDate!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.datePicked = self.recordEditorVC.date
        
        self.datePicker.setDate(self.datePicked, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        recordEditorVC.date = self.datePicked
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        datePicked = sender.date
    }
}