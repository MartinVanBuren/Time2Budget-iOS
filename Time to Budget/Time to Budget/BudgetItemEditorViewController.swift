//
//  BudgetItemEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

class BudgetItemEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var currentBudgetItem:BudgetItem!
    var finalTime = Time()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    var categoryPickerData:[String] = ["Test 1", "Test 2", "Test 3"]
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    var categoryPicked:String!
    var timePicked:Time = Time()
    var saveInfo:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        finalTime.floatToTime(currentBudgetItem.timeRemaining)
        self.navigationItem.title = currentBudgetItem.name
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        timePicker.dataSource = self
        timePicker.delegate = self
        
        categoryPicked = currentBudgetItem.category
        nameTextField.text = currentBudgetItem.name
        descriptionTextField.text = currentBudgetItem.descript
        nameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    // UIPicker Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 2
        }
        else if pickerView.tag == 2 {
            return 1
        }
        else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            if component == 0 {
                return timeHourPickerData.count
            }
            else if component == 1 {
                return timeMinutePickerData.count
            }
        }
        else if pickerView.tag == 2 {
            return categoryPickerData.count
        }
        
        return 0
    }
    
    //UIPicker Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 1 {
            if component == 0 {
                return "\(timeHourPickerData[row])"
            }
            else if component == 1 {
                return "\(timeMinutePickerData[row])"
            }
        }
        else if pickerView.tag == 2 {
            return categoryPickerData[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if component == 0 {
                timePicked.hours = timeHourPickerData[row]
            }
            else if component == 1 {
                timePicked.minutes = timeMinutePickerData[row]
            }
        }
        else if pickerView.tag == 2 {
            categoryPicked = categoryPickerData[row]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(animated: Bool) {
        if saveInfo {
            let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            
            currentBudgetItem.timeRemaining = currentBudgetItem.timeRemaining
            currentBudgetItem.name = nameTextField.text
            currentBudgetItem.descript = descriptionTextField.text
            currentBudgetItem.category = categoryPicked
            currentBudgetItem.isVisible = true
            
            appDelegate.saveContext()
        }
    }

    @IBAction func deleteButtonPressed(sender: UIButton) {
        currentBudgetItem.isVisible = false
        saveInfo = false
        self.navigationController?.popViewControllerAnimated(true)
    }
}
