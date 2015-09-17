//
//  Database.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public class Database {
    
    public class func getExampleRealm() -> Realm {
        let path = NSBundle.mainBundle().pathForResource("example", ofType: "realm")
        let exampleRealm: Realm!
        do {
            exampleRealm = try Realm(configuration: Realm.Configuration(path: path, readOnly: true))
        } catch let error as NSError {
            NSErrorPointer().memory = error
            exampleRealm = nil
        }
        
        return exampleRealm
    }
    
    public class func newBudget() throws {
        let realm = try Realm()
        
        if realm.objects(Budget).filter("isCurrent = TRUE").count > 0 {
            let oldBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
            
            realm.write {
                oldBudget.isCurrent = false
            }
            
            let newBudget = Budget()
            newBudget.autoInit()
            
            Database.migrateToNewBudget(oldBudget: oldBudget, newBudget: newBudget)
            
            realm.write {
                realm.add(newBudget)
            }
        } else {
            realm.write {
                let newBudget = Budget()
                newBudget.autoInit()
                realm.add(newBudget)
            }
        }
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().scheduleLocalNotification(try! Factory.archiveBudgetNotification())
    }
    
    public class func migrateToNewBudget(oldBudget oldBudget: Budget, newBudget: Budget) {
        let newCategories = List<Category>()
        let oldCategories = oldBudget.categories
        
        for var i = 0; i < oldCategories.count; i++ {
            let oldCategory = oldCategories[i] 
            
            let newCategory = Category()
            
            newCategory.name = oldCategory.name
            newCategory.parent = newBudget
            
            for var x = 0; x < oldCategory.tasks.count; x++ {
                let oldTask = oldCategory.tasks[x] 
                
                let newTask = Task()
                newTask.name = oldTask.name
                newTask.memo = oldTask.memo
                newTask.timeBudgeted = oldTask.timeBudgeted
                newTask.parent = newCategory
                newTask.calcTime()
                
                newCategory.tasks.append(newTask)
            }
            
            newCategory.calcTime()
            newCategories.append(newCategory)
        }
        
        for category in newCategories {
            newBudget.categories.append(category)
        }
    }
    
    public class func checkCategoryName(name name: String) throws -> Bool {
        let realm = try Realm()
        
        let budget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let count = Int(budget.categories.filter("name = '\(name)'").count)
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addCategory(name name: String) throws {
        let realm = try Realm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        
        if (try Database.checkCategoryName(name: name)) {
            realm.write {
                let newCategory = Category()
                newCategory.name = name
                newCategory.calcTime()
                currentBudget.categories.append(newCategory)
            }
        } else {
            print("Category Name Taken")
        }
    }
    
    public class func deleteCategory(categoryName categoryName: String, retainTasks: Bool) throws {
        let realm = try Realm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        let currentCategoryTasks = currentCategory.tasks
        let oldIndex = currentBudget.categories.indexOf(currentCategory)!
        let loopCount = currentCategoryTasks.count
        
        if (retainTasks) {
            if realm.objects(Category).filter("name = 'Uncategorized'").count == 0 {
                try Database.addCategory(name: "Uncategorized")
            }
            
            for var i = 0; i < loopCount; ++i {
                try Database.moveTask(task: currentCategoryTasks.first!, newCategoryName: "Uncategorized")
            }
            
            realm.write {
                currentBudget.categories.removeAtIndex(oldIndex)
                realm.delete(currentCategory)
            }
        } else {
            for var i = 0; i < loopCount; ++i {
                try Database.deleteTask(task: currentCategoryTasks.first!, retainRecords: false)
            }
            
            realm.write {
                currentBudget.categories.removeAtIndex(oldIndex)
                realm.delete(currentCategory)
            }
        }
    }
    
    public class func updateCategory(categoryName categoryName: String, newCategoryName: String) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        realm.write {
            currentCategory.name = newCategoryName
        }
    }
    
    public class func checkTaskName(name name: String, category: Category) throws -> Bool {
        let realm = try Realm()
        let count = realm.objects(Task).filter("name = '\(name)'").count
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addTask(name name: String, memo: String, time: Double, categoryName: String) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let parentCategory = (currentBudget.categories.filter("name = '\(categoryName)'")).first!
        
        if (try Database.checkTaskName(name: name, category: parentCategory)) {
            
            realm.write {
                let newTask = Task()
                
                newTask.parent = parentCategory
                newTask.name = name
                newTask.memo = memo
                newTask.timeBudgeted = time
                newTask.calcTime()
                
                parentCategory.tasks.append(newTask)
                parentCategory.calcTime()
            }
        } else {
            print("Task Name Taken")
        }
    }
    
    public class func moveTask(task task: Task, newCategoryName: String) throws {
        let realm = try Realm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let oldCategory = task.parent
        let oldIndex = oldCategory.tasks.indexOf(task)!
        let newCategory = currentBudget.categories.filter("name = '\(newCategoryName)'").first!

        realm.write {
            oldCategory.tasks.removeAtIndex(oldIndex)
            oldCategory.calcTime()
            task.parent = newCategory
            newCategory.tasks.append(task)
            newCategory.calcTime()
        }
    }
    
    public class func updateTask(task task: Task, name: String, memo: String, time: Double, categoryName: String) throws {
        let realm = try Realm()

        realm.write {
            task.name = name
            task.timeBudgeted = time
            task.memo = memo
            task.calcTime()
            task.parent.calcTime()
        }
        
        if task.parent.name != categoryName {
            try Database.moveTask(task: task, newCategoryName: categoryName)
        }
    }
    
    public class func deleteTask(task task: Task, retainRecords: Bool) throws {
        let realm = try Realm()
        //let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentRecords = task.records
        let parent = task.parent
        
        if (retainRecords) {
            let loopCount = task.records.count
            
            if realm.objects(Task).filter("name = 'Taskless Records'").count == 0 {
                try Database.addTask(name: "Taskless Records", memo: "Retained records from a deleted Task.", time: 0.0, categoryName: "\(parent.name)")
            }
            
            for var i = 0; i < loopCount; ++i {
                try Database.moveRecord(record: task.records.first!, newTaskName: "Taskless Records")
            }
        } else {
            realm.write {
                realm.delete(currentRecords)
            }
        }
        
        realm.write {
            realm.delete(task)
            parent.calcTime()
        }
    }
    
    public class func addRecord(parentTask parentTask: Task, note: String, timeSpent: Double, date: NSDate) throws {
        let realm = try Realm()

        realm.write {
            let newRecord = Record()
            
            newRecord.parent = parentTask
            newRecord.note = note
            newRecord.timeSpent = timeSpent
            newRecord.date = date
            
            parentTask.records.append(newRecord)
            parentTask.calcTime()
        }
    }
    
    public class func moveRecord(record record: Record, newTaskName: String) throws {
        let realm = try Realm()
        let oldTask = record.parent
        let oldIndex = oldTask.records.indexOf(record)!
        let newTask = (realm.objects(Task).filter("name = '\(newTaskName)'")).first!
        
        realm.write {
            oldTask.records.removeAtIndex(oldIndex)
            oldTask.calcTime()
            record.parent = newTask
            newTask.records.append(record)
            newTask.calcTime()
        }
    }
    
    public class func deleteRecord(record record: Record) throws {
        let realm = try Realm()
        let parent = record.parent
        let oldIndex = parent.records.indexOf(record)!

        realm.write {
            parent.records.removeAtIndex(oldIndex)
            realm.delete(record)
            parent.calcTime()
        }
    }
    
    public class func updateRecord(record record: Record, taskName: String, note: String, timeSpent: Double, date: NSDate) throws {
        let realm = try Realm()

        realm.write {
            record.note = note
            record.timeSpent = timeSpent
            record.date = date
            record.parent.calcTime()
        }
        
        if record.parent.name != taskName {
            try Database.moveRecord(record: record, newTaskName: taskName)
        }
    }
}