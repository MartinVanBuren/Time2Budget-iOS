//
//  TaskEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import Realm

class TaskEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var currentTask:Task!
    var currentCategory:Category!
    var finalTime = Time()
    var budgetEditorViewController: BudgetEditorViewController!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    let categoryList = Category.allObjects()
    
    var categoryPickerData:[String]!
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    var categoryPicked:String!
    var timePicked:Time = Time()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (!budgetEditorViewController.addTaskDialog) {
            finalTime.setByDouble(currentTask.timeRemaining)
            self.titleLabel.text = currentTask.name
        } else {
            finalTime.setByDouble(0.0)
            self.titleLabel.text = "Add Task"
            
        }
        
        // Prepareing category picker data
        categoryPickerData = Factory.prepareCategoryPickerData(categoryList)
        
        // Picker Datasource/Delegate Setting
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        timePicker.dataSource = self
        timePicker.delegate = self
        
        if !budgetEditorViewController.addTaskDialog {
            // Setting Current Selections
            categoryPicked = currentCategory.name
            timePicked = Time.doubleToTime(currentTask.timeRemaining)
            nameTextField.text = currentTask.name
            descriptionTextView.text = currentTask.memo
        } else {
            categoryPicked = "Uncategorized"
            timePicked = Time.doubleToTime(0.0)
            nameTextField.text = ""
            descriptionTextView.text = ""
        }
        
        nameTextField.delegate = self
        
        descriptionTextView.userInteractionEnabled = true
        
        timePicker.selectRow(getHourIndex(), inComponent: 0, animated: true)
        timePicker.selectRow(getMinIndex(), inComponent: 1, animated: true)
        categoryPicker.selectRow(getCategoryIndex(categoryPicked), inComponent: 0, animated: true)
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
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if (!budgetEditorViewController.addTaskDialog) {
            if (currentTask.name == nameTextField.text) {
                Database.updateTask(taskName: currentTask.name, name: nameTextField.text, memo: descriptionTextView.text, time: timePicked.toDouble(), categoryName: categoryPicked)
                budgetEditorViewController.addTaskDialog = false
                self.dismissViewControllerAnimated(true, completion: {})
            } else if (currentTask.name != nameTextField.text && Database.checkTaskName(name: nameTextField.text)) {
                Database.updateTask(taskName: currentTask.name, name: nameTextField.text, memo: descriptionTextView.text, time: timePicked.toDouble(), categoryName: categoryPicked)
                budgetEditorViewController.addTaskDialog = false
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
                Factory.displayAlert(viewController: self, title: "Task Name Taken", message: "'\(nameTextField.text)' is already a Task")
            }
        } else {
            if (Database.checkTaskName(name: nameTextField.text)) {
                Database.addTask(name: nameTextField.text, memo: descriptionTextView.text, time: timePicked.toDouble(), categoryName: categoryPicked)
                budgetEditorViewController.addTaskDialog = false
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
                Factory.displayAlert(viewController: self, title: "Task Name Taken", message: "'\(nameTextField.text)' is already a Task")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        budgetEditorViewController.addTaskDialog = false
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    // Helper Functions
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
    
    func getCategoryIndex(category: String) -> Int {
        
        for var index = 0; index < categoryPickerData.count; index++ {
            if categoryPickerData[index] == category {
                return index
            }
        }
        
        return 0
    }
}