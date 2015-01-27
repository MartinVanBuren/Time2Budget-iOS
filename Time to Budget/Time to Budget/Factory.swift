//
//  Factory.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import Realm

public class Factory {
    class func prepareCategoryCell (#tableView: UITableView, categoryList: RLMResults, section: Int) -> UIView {
        
        let thisCategory = categoryList.objectAtIndex(UInt(section)) as Category
        
        var totalTime:Time = Time()
        
        var preparedCell:CategoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
        
        var taskArray = thisCategory.tasks
        
        for var i = 0; i < Int(taskArray.count); i++ {
            totalTime.hours += Time(task: (taskArray.objectAtIndex(UInt(i))) as Task).hours
            totalTime.minutes += Time(task: (taskArray.objectAtIndex(UInt(i))) as Task).minutes
        }
        
        preparedCell.sectionNameLabel.text = thisCategory.name
        preparedCell.remainingTimeLabel.text = totalTime.toString()
        
        let returnedView = UIView()
        
        returnedView.addSubview(preparedCell)
        
        return returnedView
    }
    
    class func prepareTaskCell (#tableView: UITableView, categoryList: RLMResults, indexPath: NSIndexPath) -> TaskCell {
        
        let thisTask = ((categoryList.objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row)) as Task)
        
        var preparedCell:TaskCell = tableView.dequeueReusableCellWithIdentifier("TaskCell") as TaskCell
        
        preparedCell.itemNameLabel.text = thisTask.name
        preparedCell.remainingTimeLabel.text = Time.doubleToString(thisTask.timeRemaining)
        
        return preparedCell
    }
    
    class func prepareTimeHourPickerData() -> [Int] {
        var finalValue:[Int] = []
        
        for var i = 0; i <= 99; i++ {
            finalValue.append(i)
        }
        
        return finalValue
    }
    
    class func prepareTimeMinutePickerData() -> [Int] {
        var finalValue:[Int] = []
        
        for var i = 0; i < 4; i++ {
            finalValue.append(i * 15)
        }
        
        return finalValue
    }
    
    class func prepareCategoryPickerData(categoryList: RLMResults) -> [String] {
        var finalData:[String] = []
        
        for var i = 0; i < Int(categoryList.count); i++ {
            finalData.append((categoryList.objectAtIndex(UInt(i)) as Category).name)
        }
        
        return finalData
    }

    class func displayDeleteTaskAlert(#viewController: UIViewController, indexPath: NSIndexPath){
        let currentTask = ((Category.allObjects().objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row)) as Task)
        
        if (!(currentTask.name == "Taskless Records")) {
            let alert = UIAlertController(title: "Keep Records?", message: "Records will be moved to the 'Taskless Records' Task", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                Database.deleteTask(taskName: currentTask.name, retainRecords: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                Database.deleteTask(taskName: currentTask.name, retainRecords: false)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            viewController.presentViewController(alert, animated: true, completion: {})
        } else {
            Factory.displayAlert(viewController: viewController, title: "Cannot Delete", message: "'Taskless Records' is used to store Records from deleted Tasks")
        }
    }
    
    class func displayDeleteCategoryAlert(#viewController: UIViewController, categoryName: String) {
        let currentCategory = (Category.objectsWhere("name = '\(categoryName)'").objectAtIndex(0) as Category)
        
        if (!(currentCategory.name == "Uncategorized")) {
            let alert = UIAlertController(title: "Keep Tasks?", message: "Tasks will be moved to the 'Uncategorized' Category", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                Database.deleteCategory(categoryName: currentCategory.name, retainTasks: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                Database.deleteCategory(categoryName: currentCategory.name, retainTasks: false)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            viewController.presentViewController(alert, animated: true, completion: {})
        } else {
            Factory.displayAlert(viewController: viewController, title: "Cannot Delete", message: "'Uncategorized' is used to store Tasks from deleted Categories")
        }
    }

    class func displayAddCategoryAlert(viewController: UIViewController) {
        var inputTextField = UITextField()
        inputTextField.placeholder = "Enter Category Name"
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text)) {
                
                Database.addCategory(name: inputTextField.text)
            } else {
                
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField}
        
        
        viewController.presentViewController(alert, animated: true, completion: {})
        }
    
    class func displayAlert(#viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
}