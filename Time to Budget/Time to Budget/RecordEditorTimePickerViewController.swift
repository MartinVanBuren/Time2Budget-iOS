//
//  TimePickerViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class RecordEditorTimePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // Time Picker Declarations
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    var timePicked:Time = Time()
    var recordEditorVC:RecordEditorViewController!
    @IBOutlet weak var timePicker: UIPickerView!
    
    // Stop watch Declarations
    @IBOutlet weak var startButton: UIButton!
    var startTime:NSTimeInterval!
    var isStarted = false
    var timer = NSTimer()
    var finalTime = Time()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Time Picker Setup
        timePicker.dataSource = self
        timePicker.delegate = self
        
        if let unwrappedTime = recordEditorVC.timeSpent {
            timePicked = unwrappedTime
        } else {
            timePicked.hours = 0
            timePicked.minutes = 0
        }
        
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
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return "\(timeHourPickerData[row])"
        }
        else {
            return "\(timeMinutePickerData[row])"
        }
    }
    
    //IB Actions
    @IBAction func saveButtonPressed(sender: UIButton) {
        recordEditorVC.timeSpent = self.timePicked
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func startTimeButtonPressed(sender: UIButton) {
        if self.isStarted {
            self.timer.invalidate()
            self.isStarted = false
            self.timePicker.userInteractionEnabled = true
            self.startButton.setTitle(("Start " + self.finalTime.toString()), forState: UIControlState.Normal)
            self.startButton.setTitle(("Start " + self.finalTime.toString()), forState: UIControlState.Highlighted)
        } else {
            let aSelector:Selector = "updateTimer"
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            self.isStarted = true
            self.timePicker.userInteractionEnabled = false
            self.startButton.setTitle("Stop 00:00:00", forState: UIControlState.Normal)
            self.startButton.setTitle("Stop 00:00:00", forState: UIControlState.Highlighted)
        }
    }
    
    // Helper Functions
    func updateTimer() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime = currentTime - self.startTime
        
        let hours = UInt8((elapsedTime / 60.0) / 60.0)
        elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
        
        let minutes = UInt8 (elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= (NSTimeInterval(seconds))
        
        self.finalTime.hours = Int(hours)
        self.finalTime.minutes = Int(minutes)
        
        UIView.setAnimationsEnabled(false)
        self.startButton.setTitle(("Stop " + self.finalTime.toString() + secondsToString(seconds)), forState: UIControlState.Normal)
        self.startButton.setTitle(("Stop " + self.finalTime.toString() + secondsToString(seconds)), forState: UIControlState.Highlighted)
        UIView.setAnimationsEnabled(true)
        
        if (minutes == 15 || minutes == 30 || minutes == 45 || minutes == 0) {
            timePicked.minutes = self.finalTime.minutes
        }
        timePicked.hours = self.finalTime.hours
        
        timePicker.selectRow(getHourIndex(), inComponent: 0, animated: true)
        timePicker.selectRow(getMinIndex(), inComponent: 1, animated: true)
    }
    
    func secondsToString(seconds: UInt8) -> String {
        if seconds < 10 {
            return ":0" + "\(seconds)"
        } else {
            return ":\(seconds)"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            timePicked.hours = timeHourPickerData[row]
        } else {
            timePicked.minutes = timeMinutePickerData[row]
        }
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
