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
    //========== Static Properties ==========
    static var testingEnabled = false
    static var debugEnabled = false
    
    //==================== Static Methods ====================
    /**
     Calculates time to constrain time to n hours and 0 <= n <= 60 minutes.
     
     This method will take the current values of self.hours and self.minutes and convert them into a proper format.
     For Example, 5h 70m will be converted into 6h 10m
     
     - Parameter None:
     - returns: Nothing
     */
    public class func getRealm() -> Realm {
        if Database.testingEnabled {
            let config = Realm.Configuration(inMemoryIdentifier: "DatabaseTest")
            return try! Realm(configuration: config)
        } else {
            return try! Realm()
        }
    }
    
    public class func migrationHandling() {
        let config = Realm.Configuration(
            
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                
                print(oldSchemaVersion)
                if (oldSchemaVersion < 1) {
                    migration.enumerate(Budget.className()) { oldObject, newObject in
                        // Initalize clock object in Budget
                        newObject?["clock"] = migration.create(Clock.className())
                    }
                    
                    migration.enumerate(Task.className()) { oldObject, newObject in
                        // Initalize clock object in Tasks
                        newObject?["clock"] = migration.create(Clock.className())
                    }
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        _ = Database.getRealm()
    }
    
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
    
    public class func budgetSafetyNet() -> Budget {
        let realm = Database.getRealm()
        let budgetList = realm.objects(Budget).filter("isCurrent = true")
        
        if budgetList.count > 0 {
            return budgetList.first!
        } else {
            Database.newBudget()
            return realm.objects(Budget).filter("isCurrent = true").first!
        }
    }
    
    public class func newBudget() {
        let realm = Database.getRealm()
        
        let currentBudgetCount = realm.objects(Budget).filter("isCurrent = true").count
        
        if self.debugEnabled {
            print("newBudget->currentBudgetCount: ", currentBudgetCount)
        }
        
        if  currentBudgetCount > 0 {
            let oldBudget = realm.objects(Budget).filter("isCurrent = true").first!
            
            let newBudget = Budget()
            newBudget.autoInit()
            
            Database.migrateToNewBudget(oldBudget: oldBudget, newBudget: newBudget)
            
            try! realm.write {
                realm.add(newBudget)
            }
            
            try! realm.write {
                oldBudget.isCurrent = false
            }
        } else {
            try! realm.write {
                let newBudget = Budget()
                newBudget.autoInit()
                realm.add(newBudget)
            }
        }
        
        if self.debugEnabled {
            let budgets = realm.objects(Budget)
            let currentBudgets = budgets.filter("isCurrent = true")
            
            print("newBudget->All Budgets:")
            for budget in budgets {
                print(budget.name)
            }
            print("newBduget->Current Budgets:")
            for current in currentBudgets {
                print(current.name)
            }
        }
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().scheduleLocalNotification(Factory.archiveBudgetNotification())
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
    
    public class func checkCategoryName(name name: String) -> Bool {
        let realm = Database.getRealm()
        
        let budget = realm.objects(Budget).filter("isCurrent = true").first!
        let count = Int(budget.categories.filter("name = '\(name)'").count)
        
        if (count == 0) {
            return true
        } else if (count == 1) {
            return false
        } else {
            return false
        }
    }
    
    public class func addCategory(name name: String) {
        let realm = Database.getRealm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        
        if (Database.checkCategoryName(name: name)) {
            try! realm.write {
                let newCategory = Category()
                newCategory.name = name
                newCategory.calcTime()
                currentBudget.categories.append(newCategory)
            }
            
            if self.debugEnabled {
                let testCategory = realm.objects(Category).filter("name = '\(name)'").first!
                print("addCategory->testCategory.name: ", testCategory.name)
            }
            
        } else {
            if self.debugEnabled {
                print("Category Name Taken")
            }
        }
    }
    
    public class func moveCategory(categoryName categoryName: String, index: Int) {
        let realm = Database.getRealm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        let category = currentBudget.categories.filter("name = '\(categoryName)'").first!
        let oldIndex = currentBudget.categories.indexOf(category)!
        
        try! realm.write {
            currentBudget.categories.move(from: oldIndex, to: index)
        }
    }
    
    public class func deleteCategory(categoryName categoryName: String) {
        let realm = Database.getRealm()
        
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        let currentCategoryTasks = currentCategory.tasks
        let oldIndex = currentBudget.categories.indexOf(currentCategory)!
        
        for var i = 0; i < currentCategoryTasks.count; ++i {
            Database.deleteTask(task: currentCategoryTasks.first!)
        }
        
        try! realm.write {
            currentBudget.categories.removeAtIndex(oldIndex)
            realm.delete(currentCategory)
        }
    }
    
    public class func updateCategory(categoryName categoryName: String, newCategoryName: String) {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        try! realm.write {
            currentCategory.name = newCategoryName
        }
        
        if self.debugEnabled {
            let testCategory = realm.objects(Category).filter("name = '\(newCategoryName)'").first!
            print("updateCategory->newCategory.name: ", testCategory.name)
        }
    }
    
    public class func addTask(name name: String, memo: String, time: Double, categoryName: String) -> Task {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        let parentCategory = (currentBudget.categories.filter("name = '\(categoryName)'")).first!
        
        let newTask = Task()
        
        try! realm.write {
            newTask.parent = parentCategory
            newTask.name = name
            newTask.memo = memo
            newTask.timeBudgeted = time
            newTask.calcTime()
            
            parentCategory.tasks.append(newTask)
            parentCategory.calcTime()
        }
        
        if self.debugEnabled {
            //let testTask = realm.objects(Task).filter("name = '\(name)'").first!
            //print("addTask->testTask.name: ", testTask.name)
            //print("addTask->testTask.memo: ", testTask.memo)
            //print("addTask->testTask.time: ", testTask.timeBudgeted)
            //print("addTask->testTask.categoryName: ", testTask.parent.name)
        }
        
        return newTask
    }
    
    public class func moveTask(task task: Task, newCategoryName: String) -> Bool {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        let oldCategory = task.parent
        let oldIndex = oldCategory.tasks.indexOf(task)!
        let newCategory = currentBudget.categories.filter("name = '\(newCategoryName)'").first!
        
        try! realm.write {
            oldCategory.tasks.removeAtIndex(oldIndex)
            oldCategory.calcTime()
            task.parent = newCategory
            newCategory.tasks.append(task)
            newCategory.calcTime()
        }
        
        if self.debugEnabled {
            let testTask = realm.objects(Task).filter("name = '\(task.name)'").first!
            print("moveTask->testTask.name: ", testTask.name)
            print("moveTask->testTask.memo: ", testTask.memo)
            print("moveTask->testTask.time: ", testTask.timeBudgeted)
            print("moveTask->testTask.categoryName: ", testTask.parent.name)
        }
        
        return true
    }
    
    public class func moveTask(task task: Task, index: Int) -> Bool {
        let realm = Database.getRealm()
        let taskCategory = task.parent
        let oldIndex = taskCategory.tasks.indexOf(task)!
        
        try! realm.write {
            taskCategory.tasks.move(from: oldIndex, to: index)
        }
        
        if self.debugEnabled {
            print("Task moved from index: ", oldIndex, " to: ", index)
        }
        
        return true
    }
    
    public class func moveTask(task task: Task, targetCategory: Category, index: Int) -> Bool {
        let realm = Database.getRealm()
        let oldCategory = task.parent
        let oldIndex = oldCategory.tasks.indexOf(task)!
        
        try! realm.write {
            oldCategory.tasks.removeAtIndex(oldIndex)
            oldCategory.calcTime()
            task.parent = targetCategory
            targetCategory.tasks.insert(task, atIndex: index)
            targetCategory.calcTime()
        }
        
        if self.debugEnabled {
            print("Task moved from category: ", oldCategory.name, " to: ", targetCategory.name, " at index: ", index)
        }
        
        return true
    }
    
    public class func updateTask(task task: Task, name: String, memo: String, time: Double, categoryName: String) -> Bool {
        let realm = Database.getRealm()
        
        if task.parent.name == categoryName {
            try! realm.write {
                task.name = name
                task.timeBudgeted = time
                task.memo = memo
                task.calcTime()
                task.parent.calcTime()
            }
            
            if self.debugEnabled {
                let testTask = realm.objects(Task).filter("name = '\(name)'").first!
                print("moveTask->testTask.name: ", testTask.name)
                print("moveTask->testTask.memo: ", testTask.memo)
                print("moveTask->testTask.time: ", testTask.timeBudgeted)
                print("moveTask->testTask.categoryName: ", testTask.parent.name)
            }
            
            return true
        } else {
            try! realm.write {
                task.name = name
                task.timeBudgeted = time
                task.memo = memo
                task.calcTime()
                task.parent.calcTime()
            }
            
            Database.moveTask(task: task, newCategoryName: categoryName)
            
            return true
        }
    }
    
    public class func deleteTask(task task: Task) {
        let realm = Database.getRealm()
        let parent = task.parent
        
        try! realm.write {
            realm.delete(task.records)
        }
        
        try! realm.write {
            realm.delete(task)
            parent.calcTime()
        }
    }
    
    public class func addRecord(parentTask parentTask: Task, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm()

        try! realm.write {
            let newRecord = Record()
            
            newRecord.parent = parentTask
            newRecord.note = note
            newRecord.timeSpent = timeSpent
            newRecord.date = date
            
            parentTask.records.append(newRecord)
            parentTask.calcTime()
        }
        
        if self.debugEnabled {
            let testRecord = realm.objects(Task).filter("name = '\(parentTask.name)'").first!.records.filter("note = '\(note)'").first!
            print("addRecord->testRecord.note", testRecord.note)
            print("addRecord->testRecord.timeSpent", testRecord.timeSpent)
            print("addRecord->testRecord.date", testRecord.date)
            print("addRecord->testRecord.parent", testRecord.parent.name)
        }
    }
    
    public class func moveRecord(record record: Record, newTask: Task) {
        let realm = Database.getRealm()
        let oldTask = record.parent
        let oldIndex = oldTask.records.indexOf(record)!
        //let newTask = (realm.objects(Task).filter("name = '\(newTaskName)'")).first!
        
        try! realm.write {
            oldTask.records.removeAtIndex(oldIndex)
            oldTask.calcTime()
            record.parent = newTask
            newTask.records.append(record)
            newTask.calcTime()
        }
        
        if self.debugEnabled {
            //let testRecord = realm.objects(Task).filter("name = '\(newTaskName)'").first!.records.filter("note = '\(record.note)'").first!
            print("addRecord->testRecord.note", record.note)
            print("addRecord->testRecord.timeSpent", record.timeSpent)
            print("addRecord->testRecord.date", record.date)
            print("addRecord->testRecord.parent", record.parent.name)
        }
    }
    
    public class func deleteRecord(record record: Record) {
        let realm = Database.getRealm()
        let parent = record.parent
        let index = parent.records.indexOf(record)!

        try! realm.write {
            parent.records.removeAtIndex(index)
            realm.delete(record)
            parent.calcTime()
        }
    }
    
    public class func updateRecord(record record: Record, task: Task, note: String, timeSpent: Double, date: NSDate) {
        let realm = Database.getRealm()

        try! realm.write {
            record.note = note
            record.timeSpent = timeSpent
            record.date = date
            record.parent.calcTime()
        }
        
        if record.parent.name != task.name {
            Database.moveRecord(record: record, newTask: task)
        }
        if self.debugEnabled {
            //let testRecord = realm.objects(Task).filter("name = '\(taskName)'").first!.records.filter("note = '\(note)'").first!
            print("addRecord->testRecord.note", record.note)
            print("addRecord->testRecord.timeSpent", record.timeSpent)
            print("addRecord->testRecord.date", record.date)
            print("addRecord->testRecord.parent", record.parent.name)
        }
    }
    
    public class func clockInOut(budget: Budget) -> Double? {
        let realm = Database.getRealm()
        
        try! realm.write {
            budget.clock!.clockInOut()
        }
        
        if budget.clock!.clockedIn {
            return nil
        } else {
            return budget.clock!.finalTime
        }
    }
    
    public class func clockInOut(task: Task) -> Double? {
        let realm = Database.getRealm()
        
        try! realm.write {
            task.clock!.clockInOut()
        }
        
        if task.clock!.clockedIn {
            return nil
        } else {
            return task.clock!.finalTime
        }
    }
}














