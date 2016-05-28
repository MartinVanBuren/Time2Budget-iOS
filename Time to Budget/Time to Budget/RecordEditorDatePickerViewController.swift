//
//  DatePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class RecordEditorDatePickerViewController: UIViewController {

    // =========== View Properties ===========
    var recordEditorVC: RecordEditorViewController!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePicked: NSDate!
    
    // ====================== View Controller Methods ======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply the Time to Budget theme to this view, picker, and buttons.
        Style.viewController(self)
        Style.button(self.doneButton)
        Style.picker(self.datePicker)
        
        // Apply previouse date.
        self.datePicker.setDate(self.recordEditorVC.date, animated: true)
    }
    
    // ====================== IBAction Methods ======================
    @IBAction func saveButtonPressed(sender: UIButton) {
        // Update the date picked and return to previous view.
        recordEditorVC.date = self.datePicked
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        // Update the current selected date.
        datePicked = sender.date
    }
    
}
