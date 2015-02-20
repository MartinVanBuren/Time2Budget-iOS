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
    
    public class func checkCategoryName(#name: String) -> Bool {
        let count = Int(Category.objectsWhere("name = '\(name)'").count)
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addCategory(#name: String) {
        
        if (Database.checkCategoryName(name: name)) {
            let realm = Database.getRealm()
            let newCategory = Category()
            newCategory.name = name
            
            realm.beginWriteTransaction()
            realm.addObject(newCategory)
            realm.commitWriteTransaction()
        } else {
            println("Category Name Taken")
        }
    }
    
    public class func deleteCategory(#categoryName: String, retainTasks: Bool) {
        let realm = Database.getRealm();
        
        let currentCategory = (Category.objectsWhere("name = '\(categoryName)'").objectAtIndex(0) as Category)
        let currentCategoryTasks = currentCategory.tasks
        
        if (retainTasks) {
            let loopCount:UInt = currentCategoryTasks.count
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.moveTask(taskName: (currentCategoryTasks.objectAtIndex(0) as Task).name, newCategory: "Uncategorized")
            }
            
            realm.beginWriteTransaction()
            realm.deleteObject(currentCategory)
            realm.commitWriteTransaction()
        } else {
            let loopCount:UInt = currentCategoryTasks.count
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.deleteTask(taskName: (currentCategoryTasks.objectAtIndex(0) as Task).name, retainRecords: false)
            }
            
            realm.beginWriteTransaction()
            realm.deleteObject(currentCategory)
            realm.commitWriteTransaction()
        }
    }
    
    public class func updateCategory(#categoryName: String, newCategoryName: String) {
        let realm = Database.getRealm()
        let currentCategory = Category.objectsWhere("name = '\(categoryName)'").objectAtIndex(0) as Category
        
        realm.beginWriteTransaction()
        currentCategory.name = newCategoryName
        realm.commitWriteTransaction()
    }
    
    public class func checkTaskName(#name: String) -> Bool {
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
        
        if (Database.checkTaskName(name: name)) {
            let realm = Database.getRealm()
            let newTask = Task()
            var parentCategory = (Category.objectsWhere("name = '\(categoryName)'")).objectAtIndex(0) as Category
            
            newTask.parent = parentCategory
            newTask.name = name
            newTask.memo = memo
            newTask.timeRemaining = time
            
            realm.beginWriteTransaction()
            parentCategory.tasks.addObject(newTask)
            realm.commitWriteTransaction()
        } else {
            println("Task Name Taken")
        }
        
    }
    
    public class func moveTask(#taskName: String, newCategory: String) {
        let realm = Database.getRealm()
        let newTask = Task()
        let task = Task.objectsWhere("name = '\(taskName)'").objectAtIndex(0) as Task
        let category = (Category.objectsWhere("name = '\(newCategory)'")).objectAtIndex(0) as Category
        
        newTask.name = task.name
        newTask.memo = task.memo
        newTask.timeRemaining = task.timeRemaining
        newTask.records = task.records
        
        realm.beginWriteTransaction()
        realm.deleteObject(task)
        realm.commitWriteTransaction()
        
        realm.beginWriteTransaction()
        category.tasks.addObject(newTask)
        realm.commitWriteTransaction()
    }
    
    public class func updateTask(#taskName: String, name: String, memo: String, time: Double, categoryName: String) {
        let realm = Database.getRealm()
        let task = Task.objectsWhere("name = '\(taskName)'").objectAtIndex(0) as Task
        
        realm.beginWriteTransaction()
        task.name = name
        task.timeRemaining = time
        task.memo = memo
        realm.commitWriteTransaction()
        
        Database.moveTask(taskName: task.name, newCategory: categoryName)
    }
    
    public class func deleteTask(#taskName: String, retainRecords: Bool) {
        let realm = Database.getRealm();
        
        let currentTask = (Task.objectsWhere("name = '\(taskName)'").objectAtIndex(0) as Task)
        let currentTaskRecords = currentTask.records
        
        if (retainRecords) {
            let loopCount:UInt = currentTaskRecords.count
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.moveRecord(record: (currentTaskRecords.objectAtIndex(0) as Record), newTask: "Taskless Records")
            }
            
            realm.beginWriteTransaction()
            realm.deleteObject(currentTask)
            realm.commitWriteTransaction()
        } else {
            let loopCount:UInt = currentTaskRecords.count
            
            for var i:UInt = 0; i < loopCount; ++i {
                Database.deleteRecord(record: currentTaskRecords.objectAtIndex(0) as Record)
            }
            
            realm.beginWriteTransaction()
            realm.deleteObject(currentTask)
            realm.commitWriteTransaction()
        }
    }
    
    public class func addRecord(#taskName: String, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm();
        
        let parentTask = Task.objectsWhere("name = '\(taskName)'").objectAtIndex(0) as Task
        let newRecord = Record()
        
        newRecord.parent = parentTask
        newRecord.note = note
        newRecord.timeSpent = timeSpent
        newRecord.date = date
        
        realm.beginWriteTransaction()
        parentTask.records.addObject(newRecord)
        realm.commitWriteTransaction()
    }
    
    public class func moveRecord(#record: Record, newTask: String) {
        let realm = Database.getRealm()
        let tempRecord = Record()
        let task = (Task.objectsWhere("name = '\(newTask)'")).objectAtIndex(0) as Task
            
        tempRecord.date = record.date
        tempRecord.note = record.note
        tempRecord.timeSpent = record.timeSpent
        
        realm.beginWriteTransaction()
        realm.deleteObject(record)
        realm.commitWriteTransaction()
        
        realm.beginWriteTransaction()
        task.records.addObject(tempRecord)
        realm.commitWriteTransaction()
    }
    
    public class func deleteRecord(#record: Record) {
        let realm = Database.getRealm()
        
        realm.beginWriteTransaction()
        realm.deleteObject(record)
        realm.commitWriteTransaction()
    }
    
    public class func updateRecord(#record: Record, taskName: String, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm()
        
        realm.beginWriteTransaction()
        record.note = note
        record.timeSpent = timeSpent
        record.date = date
        realm.commitWriteTransaction()
        
        Database.moveRecord(record: record, newTask: taskName)
    }
}