//
//  Factory.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/14/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Factory {
    class func prepareCategoryCell (#tableView: UITableView, fetchedResultsController: NSFetchedResultsController, section: Int) -> CategoryCell {
        
        let thisTask = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as Task
        
        var totalTime:Time = Time()
        
        var preparedCell:CategoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
        
        let arraySize = fetchedResultsController.sections?[section].numberOfObjects
        
        for var i = 0; i < arraySize; i++ {
            totalTime.hours += Time(task: (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as Task)).hours
            totalTime.minutes += Time(task: (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as Task)).minutes
        }
        
        preparedCell.sectionNameLabel.text = thisTask.category
        preparedCell.remainingTimeLabel.text = totalTime.toString()
        
        return preparedCell
    }
    
    class func prepareTaskCell (#tableView: UITableView, fetchedResultsController: NSFetchedResultsController, indexPath: NSIndexPath) -> TaskCell {
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as Task
        
        var preparedCell:TaskCell = tableView.dequeueReusableCellWithIdentifier("TaskCell") as TaskCell
        
        preparedCell.itemNameLabel.text = thisTask.name
        preparedCell.remainingTimeLabel.text = Time.floatToString(thisTask.timeRemaining)
        
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
    
    class func prepareCategoryPickerData(frcCategories: NSFetchedResultsController) -> [String] {
        let categories = frcCategories.fetchedObjects
        var finalData:[String] = []
        
        for var i = 0; i < categories!.count; i++ {
            finalData.append(categories![i].name)
        }
        
        return finalData
    }
}