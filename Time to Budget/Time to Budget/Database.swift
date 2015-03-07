//
//  Database.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import Realm

public class Database {
    
    public class func getRealm() -> RLMRealm {
        return RLMRealm.defaultRealm()
    }
    
    public class func getExampleRealm() -> RLMRealm {
        let path = NSBundle.mainBundle().pathForResource("example", ofType: "realm")
        let exampleRealm = RLMRealm(path: path, readOnly: true, error: NSErrorPointer())
        
        return exampleRealm
    }
    
    public class func newBudget() {
        let realm = Database.getRealm()
        
        if Budget.objectsWhere("isCurrent = TRUE").count > 0 {
            let oldBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
            
            realm.transactionWithBlock { () -> Void in
                let newBudget = Budget()
                oldBudget.isCurrent = false
                
                newBudget.autoInit()
                newBudget.categories = Database.migrateToNewBudget(oldBudget.categories)
                
                realm.addObject(newBudget)
            }
        } else {
            realm.transactionWithBlock { () -> Void in
                let newBudget = Budget()
                
                newBudget.autoInit()
                
                realm.addObject(newBudget)
            }
        }
    }
    
    public class func migrateToNewBudget(oldCategories: RLMArray) -> RLMArray {
        let newBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        let newCategories = RLMArray(objectClassName: "Category")
        
        for var i:UInt = 0; i < oldCategories.count; i++ {
            let oldCategory = oldCategories[i] as Category
            
            let newCategory = Category()
            
            newCategory.name = oldCategory.name
            newCategory.parent = newBudget
            
            for var x:UInt = 0; x < oldCategory.tasks.count; x++ {
                let oldTask = oldCategory.tasks[x] as Task
                
                let newTask = Task()
                newTask.name = oldTask.name
                newTask.timeBudgeted = oldTask.timeBudgeted
                newTask.parent = newCategory
                newTask.calcTime()
                
                newCategory.tasks.addObject(newTask)
            }
            
            newCategory.calcTime()
            newCategories.addObject(newCategory)
        }
        
        return newCategories
    }
    
    public class func checkCategoryName(#name: String) -> Bool {
        let budget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        let count = Int(budget.categories.objectsWhere("name = '\(name)'").count)
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addCategory(#name: String) {
        let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        
        if (Database.checkCategoryName(name: name)) {
            let realm = Database.getRealm()
            
            realm.transactionWithBlock { () -> Void in
                let newCategory = Category()
                newCategory.name = name
                newCategory.calcTime()
                currentBudget.categories.addObject(newCategory)
            }
        } else {
            println("Category Name Taken")
        }
    }
    
    public class func deleteCategory(#categoryName: String, retainTasks: Bool) {
        let realm = Database.getRealm();
        
        let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        let currentCategory = (Category.objectsWhere("name = '\(categoryName)'").firstObject() as Category)
        let currentCategoryTasks = currentCategory.tasks
        let oldIndex = currentBudget.categories.indexOfObject(currentCategory)
        let loopCount:UInt = currentCategoryTasks.count
        
        if (retainTasks) {
            if Category.objectsWhere("name = 'Uncategorized'").count == 0 {
                Database.addCategory(name: "Uncategorized")
            }
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.moveTask(taskName: (currentCategoryTasks.firstObject() as Task).name, newCategoryName: "Uncategorized")
            }
            
            realm.beginWriteTransaction()
            currentBudget.categories.removeObjectAtIndex(oldIndex)
            realm.deleteObject(currentCategory)
            realm.commitWriteTransaction()
        } else {
            for var i:UInt = 0; i < loopCount; ++i {
                Database.deleteTask(taskName: (currentCategoryTasks.firstObject() as Task).name, retainRecords: false)
            }
            
            realm.beginWriteTransaction()
            currentBudget.categories.removeObjectAtIndex(oldIndex)
            realm.deleteObject(currentCategory)
            realm.commitWriteTransaction()
        }
    }
    
    public class func updateCategory(#categoryName: String, newCategoryName: String) {
        let realm = Database.getRealm()
        let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        let currentCategory = currentBudget.categories.objectsWhere("name = '\(categoryName)'").firstObject() as Category
        
        realm.beginWriteTransaction()
        currentCategory.name = newCategoryName
        realm.commitWriteTransaction()
    }
    
    public class func checkTaskName(#name: String, category: Category) -> Bool {
        let count = Int(Task.objectsWhere("name = '\(name)'").count)
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addTask(#name: String, memo: String, time: Double, categoryName: String) {
        let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
        let parentCategory = (currentBudget.categories.objectsWhere("name = '\(categoryName)'")).firstObject() as Category
        
        if (Database.checkTaskName(name: name, category: parentCategory)) {
            let realm = Database.getRealm()
            
            
            realm.transactionWithBlock { () -> Void in
                let newTask = Task()
                
                newTask.parent = parentCategory
                newTask.name = name
                newTask.memo = memo
                newTask.timeBudgeted = time
                newTask.calcTime()
                
                parentCategory.tasks.addObject(newTask)
                parentCategory.calcTime()
            }
        } else {
            println("Task Name Taken")
        }
    }
    
    public class func moveTask(#taskName: String, newCategoryName: String) {
        let realm = Database.getRealm()
        let task = Task.objectsWhere("name = '\(taskName)'").firstObject() as Task
        let oldCategory = task.parent
        let oldIndex = oldCategory.tasks.indexOfObject(task)
        let newCategory = (Category.objectsWhere("name = '\(newCategoryName)'")).firstObject() as Category

        realm.transactionWithBlock { () -> Void in
            oldCategory.tasks.removeObjectAtIndex(oldIndex)
            oldCategory.calcTime()
            task.parent = newCategory
            newCategory.tasks.addObject(task)
            newCategory.calcTime()
        }
    }
    
    public class func updateTask(#taskName: String, name: String, memo: String, time: Double, categoryName: String) {
        let realm = Database.getRealm()
        let task = Task.objectsWhere("name = '\(taskName)'").firstObject() as Task

        realm.transactionWithBlock { () -> Void in
            task.name = name
            task.timeBudgeted = time
            task.memo = memo
            task.calcTime()
            task.parent.calcTime()
        }
        
        if task.parent.name != categoryName {
            Database.moveTask(taskName: task.name, newCategoryName: categoryName)
        }
    }
    
    public class func deleteTask(#taskName: String, retainRecords: Bool) {
        let realm = Database.getRealm()
        let currentTask = (Task.objectsWhere("name = '\(taskName)'").firstObject() as Task)
        let currentRecords = currentTask.records
        let parent = currentTask.parent
        
        if (retainRecords) {
            let loopCount:UInt = currentTask.records.count
            
            if Task.objectsWhere("name = 'Taskless Records'").count == 0 {
                Database.addTask(name: "Taskless Records", memo: "Retained records from a deleted Task.", time: 0.0, categoryName: "\(parent.name)")
            }
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.moveRecord(record: (currentTask.records.firstObject() as Record), newTaskName: "Taskless Records")
            }
        } else {
            realm.transactionWithBlock { () -> Void in
                realm.deleteObjects(currentRecords)
            }
        }
        
        realm.transactionWithBlock { () -> Void in
            realm.deleteObject(currentTask)
            parent.calcTime()
        }
    }
    
    public class func addRecord(#taskName: String, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm();
        let parentTask = Task.objectsWhere("name = '\(taskName)'").firstObject() as Task

        realm.transactionWithBlock { () -> Void in
            let newRecord = Record()
            
            newRecord.parent = parentTask
            newRecord.note = note
            newRecord.timeSpent = timeSpent
            newRecord.date = date
            
            parentTask.records.addObject(newRecord)
            parentTask.calcTime()
        }
    }
    
    public class func moveRecord(#record: Record, newTaskName: String) {
        let realm = Database.getRealm()
        let oldTask = record.parent
        let oldIndex = oldTask.records.indexOfObject(record)
        let newTask = (Task.objectsWhere("name = '\(newTaskName)'")).firstObject() as Task
        
        realm.transactionWithBlock { () -> Void in
            oldTask.records.removeObjectAtIndex(oldIndex)
            oldTask.calcTime()
            record.parent = newTask
            newTask.records.addObject(record)
            newTask.calcTime()
        }
    }
    
    public class func deleteRecord(#record: Record) {
        let realm = Database.getRealm()
        let parent = record.parent
        let oldIndex = parent.records.indexOfObject(record)

        realm.transactionWithBlock { () -> Void in
            parent.records.removeObjectAtIndex(oldIndex)
            realm.deleteObject(record)
            parent.calcTime()
        }
    }
    
    public class func updateRecord(#record: Record, taskName: String, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm()

        realm.transactionWithBlock { () -> Void in
            record.note = note
            record.timeSpent = timeSpent
            record.date = date
            record.parent.calcTime()
        }
        
        if record.parent.name != taskName {
            Database.moveRecord(record: record, newTaskName: taskName)
        }
    }
}