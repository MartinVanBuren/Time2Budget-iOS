//
//  BudgetItemEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import CoreData

class BudgetItemEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var currentBudgetItem:BudgetItem!
    var finalTime = Time()
    var addTaskDialog:Bool = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let managedObjectContext = CoreDataController.getManagedObjectContext()
    var frcCategories:NSFetchedResultsController = NSFetchedResultsController()
    
    var categoryPickerData:[String]!
    var timeHourPickerData:[Int] = Factory.prepareTimeHourPickerData()
    var timeMinutePickerData:[Int] = Factory.prepareTimeMinutePickerData()
    var categoryPicked:String!
    var timePicked:Time = Time()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !addTaskDialog {
            finalTime.floatToTime(currentBudgetItem.timeRemaining)
            //self.navigationItem.title = currentBudgetItem.name
            self.titleLabel.text = "Edit Task"
        } else {
            finalTime.setByFloat(0.0)
            //self.navigationItem.title = "New Task"
            self.titleLabel.text = "Add Task"
            
        }
        
        // Core Data - Fetching Category Item
        frcCategories = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.fetchCategoryItemRequest(), managedObjectContext: managedObjectContext)
        frcCategories.delegate = self
        frcCategories.performFetch(nil)
        
        // Prepareing category picker data
        categoryPickerData = Factory.prepareCategoryPickerData(frcCategories)
        
        // Picker Datasource/Delegate Setting
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        timePicker.dataSource = self
        timePicker.delegate = self
        
        if !addTaskDialog {
            // Setting Current Selections
            categoryPicked = currentBudgetItem.category
            timePicked = Time.floatToTime(currentBudgetItem.timeRemaining)
            nameTextField.text = currentBudgetItem.name
            descriptionTextView.text = currentBudgetItem.descript
        } else {
            categoryPicked = "Uncategorized"
            timePicked = Time.floatToTime(0.0)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if !addTaskDialog {
            let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            
            currentBudgetItem.timeRemaining = timePicked.toFloat()
            currentBudgetItem.name = nameTextField.text
            currentBudgetItem.descript = descriptionTextView.text
            currentBudgetItem.category = categoryPicked
            currentBudgetItem.isVisible = true
            
            appDelegate.saveContext()
        } else {
            CoreDataController.addBudgetItem(name: nameTextField.text, descript: descriptionTextView.text, category: categoryPicked, newTime: timePicked.toFloat())
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.addTaskDialog = false
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
