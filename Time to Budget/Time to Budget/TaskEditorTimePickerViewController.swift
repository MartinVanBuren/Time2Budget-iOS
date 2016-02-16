//
//  TaskEditorTimePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class TaskEditorTimePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //========== View Properties ==========
    var timePicked:Time = Time()
    var taskEditorVC:TaskEditorViewController!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var colonLabel: UILabel!
    
    //========== Time Picker Properties ==========
    @IBOutlet weak var timePicker: UIPickerView!
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply the Time to Budget theme to this view.
        Style.viewController(self)
        Style.button(self.doneButton)
        Style.label(colonLabel)
        
        // Apply previous time if any to the UIPicker.
        if let unwrappedTime = taskEditorVC.taskTime {
            timePicked = Time(newTime: unwrappedTime)
        } else {
            timePicked.hours = 0
            timePicked.minutes = 0
        }
        
        // Update UIPicker to reflect above changes.
        timePicker.selectRow(getHourIndex(), inComponent: 0, animated: true)
        timePicker.selectRow(getMinIndex(), inComponent: 1, animated: true)
    }
    
    //==================== UIPickerDataSource Methods ====================
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return timeHourPickerData.count
        } else {
            return timeMinutePickerData.count
        }
    }
    
    //==================== UIPickerDelegate Methods ====================
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return Style.picker(timeHourPickerData[row])
        }
        else {
            return Style.picker(timeMinutePickerData[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            timePicked.hours = timeHourPickerData[row]
        } else {
            timePicked.minutes = timeMinutePickerData[row]
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func doneButtonPressed(sender: UIButton) {
        taskEditorVC.taskTime = self.timePicked.toDouble()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //==================== Helper Methods ====================
    /**
    Returns the integer index for the currently selected hour based on the self.timePicked.hours property.
    
    - Parameter None:
    - returns: Int index for the currently selected hour.
    */
    func getHourIndex() -> Int {
        return timePicked.hours
    }
    
    /**
     Returns the integer index for the currently selected minutes based on the seld.timePicked.minutes property.
     
     - Parameter None:
     - returns: Int index for the currently selected minutes.
     */
    func getMinIndex() -> Int {
        if timePicked.minutes == 15 {
            return 1
        }
        else if timePicked.minutes == 30 {
            return 2
        }
        else if timePicked.minutes == 45 {
            return 3
        }
        else {
            return 0
        }
    }
}
