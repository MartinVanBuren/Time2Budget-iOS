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

class Factory {
    class func prepareCategoryCell (#tableView: UITableView, categoryList: RLMResults, section: Int) -> CategoryCell {
        
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
        
        return preparedCell
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

    class func prepareDeleteTaskAlert(#indexPath: NSIndexPath) -> UIAlertController {
        
        var alert = UIAlertController(title: "Save Task Records?", message: "Task records will be moved to a task named \"Taskless Records\"", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteTask(indexPath: indexPath, retainRecords: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteTask(indexPath: indexPath, retainRecords: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

        return alert
    }

    class func prepareAddCategoryAlert() -> UIAlertController {
        var inputTextField = UITextField()
        inputTextField.placeholder = "Enter Category Name"
        
        var alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        //var alert = UIAlertView(title: "New Category", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.addCategory(name: inputTextField.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField}
        
        return alert
    }
}