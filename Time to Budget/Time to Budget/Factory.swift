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
    class func prepareCategoryCell(#tableView: UITableView, categoryList: RLMResults, section: Int, isEditor: Bool) -> UIView {
        
        let thisCategory = categoryList.objectAtIndex(UInt(section)) as Category
        
        var preparedCell:CategoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
        
        var taskArray = thisCategory.tasks
        
        preparedCell.sectionNameLabel.text = thisCategory.name
        if !isEditor {
            preparedCell.remainingTimeLabel.text = Time.doubleToString(thisCategory.totalTimeRemaining)
        } else {
            preparedCell.remainingTimeLabel.text = Time.doubleToString(thisCategory.totalTimeBudgeted)
        }
        
        let returnedView = UIView()
        
        returnedView.addSubview(preparedCell)
        
        return returnedView
    }
    
    class func prepareTaskCell(#tableView: UITableView, categoryList: RLMResults, indexPath: NSIndexPath, isEditor: Bool) -> UITableViewCell {
        
        let thisTask = ((categoryList.objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row)) as Task)
        
        var preparedCell = tableView.dequeueReusableCellWithIdentifier("TaskCell") as SubtitleDetailCell
        
        preparedCell.title.text = thisTask.name
        preparedCell.subtitle.text = thisTask.memo
        
        if !isEditor {
            preparedCell.detail.text = Time.doubleToString(thisTask.timeRemaining)
        } else {
            preparedCell.detail.text = Time.doubleToString(thisTask.timeBudgeted)
        }
        
        return preparedCell
    }
    
    class func prepareAddRecordTaskCell(#tableView: UITableView, currentTask:Task?) -> UITableViewCell {
        var taskCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
        taskCell.textLabel?.text = "Task"
        
        if let unwrappedTaskName = currentTask?.name {
            taskCell.detailTextLabel?.text = unwrappedTaskName
            taskCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            taskCell.detailTextLabel?.text = "Choose a Task"
        }
        
        taskCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return taskCell
    }
    
    class func prepareAddRecordTimeCell(#tableView: UITableView, timeSpent: Time?) -> UITableViewCell {
        var timeSpentCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
        timeSpentCell.textLabel?.text = "Time Spent"
        
        if let unwrappedTimeSpent = timeSpent?.toDouble() {
            timeSpentCell.detailTextLabel?.text = Time.doubleToString(unwrappedTimeSpent)
            timeSpentCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            timeSpentCell.detailTextLabel?.text = "00:00"
        }
        
        timeSpentCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return timeSpentCell
    }
    
    class func prepareAddRecordDateCell(#tableView: UITableView, date: NSDate?) -> UITableViewCell {
        var dateCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
        dateCell.textLabel?.text = "Date"
        
        if let unwrappedDate = date? {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            
            dateCell.detailTextLabel?.text = dateFormatter.stringFromDate(unwrappedDate)
            dateCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            dateCell.detailTextLabel?.text = "Current Date"
        }
        
        dateCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return dateCell
    }
    
    class func prepareAddRecordMemoCell(#tableView: UITableView, memo: String?) -> UITableViewCell {
        var memoCell = tableView.dequeueReusableCellWithIdentifier("RecordMemoCell") as MemoCell
        
        if let unwrappedMemo = memo? {
            memoCell.memoTextField.text = unwrappedMemo
        } else {
            memoCell.memoTextField.placeholder = "(Optional) Enter a Memo"
        }
    
        return memoCell
    }
    
    class func prepareRecordCell(#tableView: UITableView, recordList: RLMArray, indexPath: NSIndexPath) -> UITableViewCell {
        var preparedCell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as SubtitleDetailCell
        let thisRecord = recordList.objectAtIndex(UInt(indexPath.row)) as Record
        
        preparedCell.title.text = thisRecord.note
        preparedCell.subtitle.text = thisRecord.dateToString()
        preparedCell.detail.text = Time.doubleToString(thisRecord.timeSpent)
        
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

    class func displayDeleteTaskAlert(#viewController: BudgetEditorViewController, indexPath: NSIndexPath){
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

    class func displayAddCategoryAlert(#viewController: UIViewController) {
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
    
    class func displayEditCategoryAlert(#viewController: UIViewController, categoryName: String) {
        var inputTextField = UITextField()
        let category = Category.objectsWhere("name = '\(categoryName)'").firstObject() as Category
        //inputTextField.text = category.name
        
        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Factory.displayDeleteCategoryAlert(viewController: viewController, categoryName: category.name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text) || category.name == inputTextField.text) {
                
                Database.updateCategory(categoryName: category.name, newCategoryName: inputTextField.text)
            } else {
                
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
            }
        }))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField; inputTextField.text = category.name}
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteRecordAlert(viewController: UIViewController, record: Record) {
        
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you wwant to delete this task?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteRecord(record: record)
            (viewController as RecordsViewController).tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayAlert(#viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
}