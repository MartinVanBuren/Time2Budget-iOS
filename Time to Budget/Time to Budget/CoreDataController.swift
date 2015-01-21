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
    
    class func getFetchRequest(itemName: String) -> NSFetchRequest {
        if (itemName == "Tasks"){
            let fetchRequest = NSFetchRequest(entityName: "Task")
            let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
            
            return fetchRequest
        } else if (itemName == "Categories") {
            let fetchRequest = NSFetchRequest(entityName: "Category")
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            return fetchRequest
        } else if (itemName == "Records") {
            let fetchRequest = NSFetchRequest(entityName: "Record")
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            return fetchRequest
        }
        
        return NSFetchRequest()
    }
    
    class func getFetchedResultsController(#fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController {
        var fetchedResultsController:NSFetchedResultsController!
        
        if fetchRequest.entityName == "Task" {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "category", cacheName: nil)
        }
        else if fetchRequest.entityName == "Category" {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "name", cacheName: nil)
        }
        else if fetchRequest.entityName == "Record" {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "name", cacheName: nil)
        }
        else {
            return NSFetchedResultsController()
        }
        
        return fetchedResultsController
    }
    
    class func addTask(#name: String, descript: String, category: String, newTime: Float) {
        let managedObjectContext = CoreDataController.getManagedObjectContext()
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        let newTask = Task(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                
        newTask.name = name
        newTask.descript = descript
        newTask.category = category
        newTask.timeRemaining = newTime
        newTask.isVisible = true
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "Task")
        var error:NSError? = nil
        var results:NSArray = managedObjectContext.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
    }
    
    class func addCategory(#categoryName: String) {
        let managedObjectContext = CoreDataController.getManagedObjectContext()
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)
        let newCategory = Category(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let newTime = Time(newHours: 0, newMinutes: 0)
        
        newCategory.name = categoryName
        newCategory.totalTimeRemaining = newTime.toFloat()
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "Category")
        var error:NSError? = nil
        var results:NSArray = managedObjectContext.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
    }
    
    class func deleteTask(#frcTasks: NSFetchedResultsController, indexPath: NSIndexPath, retainRecords: Bool) {
        let managedObjectContext = CoreDataController.getManagedObjectContext()
        /*
        // Finish records retention code
        if (retainRecords){
            var frcRecords = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.getFetchRequest("Records"), managedObjectContext: managedObjectContext)
            var fetchedObjects = frcRecords.fetchedObjects
            
            for var i = 0; i < fetchedObjects?.count; i++ {
                fetchedObjects?[indexPath.section][i].setValue("Taskless Records", forKey: "taskName")
            }
            
        } else {
            
        }
        
        managedObjectContext.deleteObject(frcTasks.objectAtIndexPath(indexPath) as NSManagedObject)
        
        var error:NSErrorPointer = nil
        if (managedObjectContext.save(error)){

        }
        */
    }
}