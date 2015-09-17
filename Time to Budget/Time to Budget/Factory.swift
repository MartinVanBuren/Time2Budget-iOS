//
//  Factory.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public class Factory {
    class func prepareCategoryCell(tableView tableView: UITableView, categoryList: List<Category>, section: Int, isEditor: Bool) -> UIView {
        
        let thisCategory = categoryList[section]
        
        let preparedCell:CategoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        
        //var taskArray = thisCategory.tasks
        
        preparedCell.sectionNameLabel.text = thisCategory.name
        preparedCell.sectionNameLabel.textColor = UIColor.whiteColor()
        
        if !isEditor {
            preparedCell.remainingTimeLabel.text = Time.doubleToString(thisCategory.totalTimeRemaining)
            
            if thisCategory.totalTimeRemaining > 0.0 {
                preparedCell.remainingTimeLabel.backgroundColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
            } else if thisCategory.totalTimeRemaining < 0.0 {
                preparedCell.remainingTimeLabel.backgroundColor = UIColor.redColor()
            } else {
                preparedCell.remainingTimeLabel.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
            }
        } else {
            preparedCell.remainingTimeLabel.text = Time.doubleToString(thisCategory.totalTimeBudgeted)
            preparedCell.remainingTimeLabel.backgroundColor = UIColor.darkGrayColor()
        }
        
        preparedCell.remainingTimeLabel.layer.cornerRadius = CGRectGetWidth(preparedCell.remainingTimeLabel.frame)/8
        preparedCell.remainingTimeLabel.layer.borderWidth = 1.0
        preparedCell.remainingTimeLabel.layer.masksToBounds = true
        preparedCell.remainingTimeLabel.frame.insetInPlace(dx: CGFloat(5), dy: CGFloat(5))
        preparedCell.remainingTimeLabel.textColor = UIColor.whiteColor()
        preparedCell.backgroundColor = UIColor(red: 122/255, green: 158/255, blue: 224/255, alpha: 255/255)
        preparedCell.opaque = false
        preparedCell.alpha = 0.75
        
        let returnedView = UIView()
        
        returnedView.addSubview(preparedCell)
        returnedView.backgroundColor = UIColor(red: (204/255), green: (204/255), blue: (204/255), alpha: 0.65)
        
        return returnedView
    }
    
    class func prepareTaskCell(tableView tableView: UITableView, categoryList: List<Category>, indexPath: NSIndexPath, isEditor: Bool) -> UITableViewCell {
        
        let thisTask = categoryList[indexPath.section].tasks[indexPath.row]
        
        let preparedCell = tableView.dequeueReusableCellWithIdentifier("TaskSubtitleCell") as! SubtitleDetailCell
        
        preparedCell.title.text = thisTask.name
        preparedCell.subtitle.text = thisTask.memo
        
        if !isEditor {
            preparedCell.detail.text = Time.doubleToString(thisTask.timeRemaining)
            
            if thisTask.timeRemaining > 0.0 {
                preparedCell.detail.textColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
            } else if thisTask.timeRemaining < 0.0 {
                preparedCell.detail.textColor = UIColor.redColor()
            } else {
                preparedCell.detail.textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
            }
            
        } else {
            preparedCell.detail.text = Time.doubleToString(thisTask.timeBudgeted)
            preparedCell.detail.textColor = UIColor.darkGrayColor()
        }
        
        return preparedCell
    }
    
    class func prepareAddRecordTaskCell(tableView tableView: UITableView, currentTask:Task?) -> UITableViewCell {
        let taskCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
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
    
    class func prepareAddRecordTimeCell(tableView tableView: UITableView, timeSpent: Time?) -> UITableViewCell {
        let timeSpentCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
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
    
    class func prepareAddRecordDateCell(tableView tableView: UITableView, date: NSDate?) -> UITableViewCell {
        let dateCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RecordRightDetailCell")
        
        dateCell.textLabel?.text = "Date"
        
        if let unwrappedDate = date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            
            dateCell.detailTextLabel?.text = dateFormatter.stringFromDate(unwrappedDate)
            dateCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            dateCell.detailTextLabel?.text = "Current Date"
        }
        
        dateCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return dateCell
    }
    
    class func prepareAddRecordMemoCell(tableView tableView: UITableView, memo: String?) -> UITableViewCell {
        let memoCell = tableView.dequeueReusableCellWithIdentifier("RecordMemoCell") as! MemoCell
        
        if let unwrappedMemo = memo {
            memoCell.memoTextField.text = unwrappedMemo
        } else {
            memoCell.memoTextField.placeholder = "(Optional) Enter a Memo"
        }
    
        return memoCell
    }
    
    class func prepareAddTaskNameCell(tableView tableView: UITableView, name: String?) -> UITableViewCell {
        let preparedCell = tableView.dequeueReusableCellWithIdentifier("taskNameCell") as! TextfieldCell
        
        if let unwrappedName = name {
            preparedCell.textField.text = unwrappedName
        } else {
            preparedCell.textField.placeholder = "Task Name"
        }
        
        return preparedCell
    }
    
    class func prepareAddTaskMemoCell(tableView tableView: UITableView, memo: String?) -> UITableViewCell {
        let preparedCell = tableView.dequeueReusableCellWithIdentifier("taskMemoCell") as! TextfieldCell
        
        if let unwrappedMemo = memo {
            preparedCell.textField.text = unwrappedMemo
        } else {
            preparedCell.textField.placeholder = "Memo (Optional)"
        }
        
        return preparedCell
    }
    
    class func prepareAddTaskCategoryCell(tableView tableView: UITableView, categoryName: String?) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "rightDetailCell")
        
        preparedCell.textLabel?.text = "Category"
        
        if let unwrappedCategoryName = categoryName {
            preparedCell.detailTextLabel?.text = unwrappedCategoryName
            preparedCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            preparedCell.detailTextLabel?.text = "Choose Category"
        }
        
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    class func prepareAddTaskTimeCell(tableView tableView: UITableView, time: Double?) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "rightDetailCell")
        
        preparedCell.textLabel?.text = "Time Budgeted"
        
        if let unwrappedTime = time {
            preparedCell.detailTextLabel?.text = Time.doubleToString(unwrappedTime)
            preparedCell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            preparedCell.detailTextLabel?.text = "00:00"
        }
        
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    class func prepareRecordCell(tableView tableView: UITableView, recordList: List<Record>, indexPath: NSIndexPath) -> UITableViewCell {
        let preparedCell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as! SubtitleDetailCell
        let thisRecord = recordList[indexPath.row]
        
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
    
    class func prepareCategoryPickerData(categoryList: Results<Category>) -> [String] {
        var finalData:[String] = []
        
        for var i = 0; i < Int(categoryList.count); i++ {
            finalData.append(categoryList[i].name)
        }
        
        return finalData
    }
    
    class func prepareSettingsAboutCell(tableView tableView: UITableView) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "AboutCell")
        
        preparedCell.textLabel?.text = "©2015 Arrken Software LLC"
        preparedCell.detailTextLabel?.text = "Designed and Developed by Robert Kennedy"
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    class func prepareBasicCell(tableView tableView: UITableView, titleText: String) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "BasicCell")
        
        preparedCell.textLabel?.text = titleText
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    class func prepareBasicHeader(tableView tableView: UITableView, titleText: String) -> UIView {
        let preparedView = UIView()
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        
        cell.remainingTimeLabel.hidden = true
        cell.sectionNameLabel.text = titleText
        cell.sectionNameLabel.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(red: 122/255, green: 158/255, blue: 224/255, alpha: 255/255)
        
        preparedView.addSubview(cell)
        
        return preparedView
    }

    class func displayDeleteTaskAlert(viewController viewController: BudgetEditorViewController, indexPath: NSIndexPath) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories[indexPath.section]
        let currentTask = currentCategory.tasks[indexPath.row]
        
        let alert = UIAlertController(title: "Keep Records?", message: "Records will be moved to the 'Taskless Records' Task", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Database.deleteTask(task: currentTask, retainRecords: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Database.deleteTask(task: currentTask, retainRecords: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteCategoryAlert(viewController viewController: UIViewController, categoryName: String) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        let alert = UIAlertController(title: "Keep Tasks?", message: "Tasks will be moved to the 'Uncategorized' Category", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Database.deleteCategory(categoryName: currentCategory.name, retainTasks: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Database.deleteCategory(categoryName: currentCategory.name, retainTasks: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
        viewController.presentViewController(alert, animated: true, completion: {})
    }

    class func displayAddCategoryAlert(viewController viewController: UIViewController) {
        var inputTextField = UITextField()
        inputTextField.placeholder = "Enter Category Name"
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (try! Database.checkCategoryName(name: inputTextField.text!)) {
                
                try! Database.addCategory(name: inputTextField.text!)
            } else {
                
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField; inputTextField.autocapitalizationType = UITextAutocapitalizationType.Words}
        
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayEditCategoryAlert(viewController viewController: UIViewController, categoryName: String) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        var inputTextField = UITextField()
        let category = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Factory.displayDeleteCategoryAlert(viewController: viewController, categoryName: category.name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (try! Database.checkCategoryName(name: inputTextField.text!) || category.name == inputTextField.text) {
                try! Database.updateCategory(categoryName: category.name, newCategoryName: inputTextField.text!)
            } else {
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
            }
        }))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField; inputTextField.text = category.name; inputTextField.autocapitalizationType = UITextAutocapitalizationType.Words}
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteRecordAlert(viewController: UIViewController, record: Record) {
        
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! Database.deleteRecord(record: record)
            (viewController as! RecordsViewController).tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayAlert(viewController viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func archiveBudgetNotification() throws -> UILocalNotification {
        let realm = try Realm()
        let thisBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let localNotif = UILocalNotification()
        
        localNotif.alertTitle = "Budget Archived"
        localNotif.alertBody = "Your fresh budget is ready!"
        localNotif.fireDate = thisBudget.endDate
        
        return localNotif
    }
    
}