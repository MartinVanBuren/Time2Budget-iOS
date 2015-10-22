//
//  TaskEditorTimePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class TaskEditorTimePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // Time Picker Declarations
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    var timePicked:Time = Time()
    var taskEditorVC:TaskEditorViewController!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let unwrappedTime = taskEditorVC.taskTime {
            timePicked = Time.doubleToTime(unwrappedTime)
        } else {
            timePicked.hours = 0
            timePicked.minutes = 0
        }
        
        doneButton.layer.cornerRadius = CGRectGetWidth(doneButton.frame)/8
        doneButton.layer.masksToBounds = true
        
        timePicker.selectRow(getHourIndex(), inComponent: 0, animated: true)
        timePicker.selectRow(getMinIndex(), inComponent: 1, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// UIPicker Data Sources
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
    
    //UIPicker Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(timeHourPickerData[row])"
        }
        else {
            return "\(timeMinutePickerData[row])"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            timePicked.hours = timeHourPickerData[row]
        } else {
            timePicked.minutes = timeMinutePickerData[row]
        }
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        taskEditorVC.taskTime = self.timePicked.toDouble()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getHourIndex() -> Int {
        return timePicked.hours
    }
    
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
