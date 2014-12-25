//
//  CoreDataController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/21/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController {
    class func getManagedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    }
    
    class func fetchBudgetItemRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "BudgetItem")
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        
        return fetchRequest
    }
    
    class func fetchCategoryItemRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "CategoryItem")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func getFetchedResultsController(#fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController {
        var fetchedResultsController:NSFetchedResultsController!
        
        if fetchRequest.entityName == "BudgetItem" {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "category", cacheName: nil)
        }
        else if fetchRequest.entityName == "CategoryItem" {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "name", cacheName: nil)
        }
        else {
            return NSFetchedResultsController()
        }
        
        return fetchedResultsController
    }
    
    class func addBudgetItem() {
        let managedObjectContext = CoreDataController.getManagedObjectContext()
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("BudgetItem", inManagedObjectContext: managedObjectContext)
        let testBudgetItem = BudgetItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let newTime = Time(newHours: 5, newMinutes: 15)
        
        testBudgetItem.name = "Test Budget Item"
        testBudgetItem.descript = "This is a Test"
        testBudgetItem.category = "Uncategorized"
        testBudgetItem.timeRemaining = newTime.toFloat()
        testBudgetItem.isVisible = true
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "BudgetItem")
        var error:NSError? = nil
        var results:NSArray = managedObjectContext.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
    }
    
    class func addCategoryItem() {
        let managedObjectContext = CoreDataController.getManagedObjectContext()
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("CategoryItem", inManagedObjectContext: managedObjectContext)
        let testCat = CategoryItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let newTime = Time(newHours: 0, newMinutes: 0)
        
        testCat.name = "newCategory"
        testCat.totalTimeRemaining = newTime.toFloat()
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "CategoryItem")
        var error:NSError? = nil
        var results:NSArray = managedObjectContext.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
    }
}