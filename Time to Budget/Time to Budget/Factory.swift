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
    class func prepareSectionHeaderCell (#tableView: UITableView, fetchedResultsController: NSFetchedResultsController, section: Int) -> SectionHeaderCell {
        
        let thisBudgetItem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as BudgetItem
        
        var totalTime:Time = Time()
        
        var preparedCell:SectionHeaderCell = tableView.dequeueReusableCellWithIdentifier("SectionHeaderCell") as SectionHeaderCell
        
        let arraySize = fetchedResultsController.sections?[section].numberOfObjects
        
        for var i = 0; i < arraySize; i++ {
            totalTime.hours += Time(budgetItem: (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as BudgetItem)).hours
            totalTime.minutes += Time(budgetItem: (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as BudgetItem)).minutes
        }
        
        preparedCell.sectionNameLabel.text = thisBudgetItem.category
        preparedCell.remainingTimeLabel.text = totalTime.toString()
        
        return preparedCell
    }
    
    class func prepareBudgetItemCell (#tableView: UITableView, fetchedResultsController: NSFetchedResultsController, indexPath: NSIndexPath) -> BudgetItemCell {
        
        let thisBudgetItem = fetchedResultsController.objectAtIndexPath(indexPath) as BudgetItem
        
        var preparedCell:BudgetItemCell = tableView.dequeueReusableCellWithIdentifier("BudgetItemCell") as BudgetItemCell
        
        preparedCell.itemNameLabel.text = thisBudgetItem.name
        preparedCell.remainingTimeLabel.text = Time.toString(thisBudgetItem.timeRemaining)
        
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
}