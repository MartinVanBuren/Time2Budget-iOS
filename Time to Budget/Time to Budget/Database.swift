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
    
    public class func addCategory(#name: String) {
        
        let realm = Database.getRealm()
        let newCategory = Category()
        newCategory.name = name
            
        realm.beginWriteTransaction()
        realm.addObject(newCategory)
        realm.commitWriteTransaction()
        
    }
    
    public class func addTask(#name: String, memo: String, time: Double, categoryName: String) {
        
        let realm = Database.getRealm()
        let newTask = Task()
        var category = (Category.objectsWhere("name = '\(categoryName)'")).objectAtIndex(0) as Category
        
        newTask.name = name
        newTask.memo = memo
        newTask.timeRemaining = time
            
        realm.beginWriteTransaction()
        category.tasks.addObject(newTask)
        realm.commitWriteTransaction()
        
    }
    
    public class func moveTask(#task: Task, newCategory: String) {
        let realm = Database.getRealm()
        var newTask = Task()
        var category = (Category.objectsWhere("name = '\(newCategory)'")).objectAtIndex(0) as Category
        
        realm.beginWriteTransaction()
        newTask.name = task.name
        newTask.memo = task.memo
        newTask.timeRemaining = task.timeRemaining
        newTask.records = task.records
        realm.deleteObject(task)
        category.tasks.addObject(newTask)
        realm.commitWriteTransaction()
    }
    
    public class func updateTask(#task: Task, name: String, memo: String, time: Double, categoryName: String) {
        let realm = Database.getRealm()
        
        realm.beginWriteTransaction()
        task.name = name
        task.timeRemaining = time
        task.memo = memo
        realm.commitWriteTransaction()
        
        Database.moveTask(task: task, newCategory: categoryName)
        
    }
    
    public class func deleteTask(#indexPath: NSIndexPath, retainRecords: Bool) {
        let realm = Database.getRealm();
        
        let currentTask = ((Category.allObjects().objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row)) as Task)
        
        if (retainRecords) {
            let currentTaskRecords = currentTask.records
            let tasklessRecordsTask = (Task.objectsWhere("name = 'Taskless Records'").objectAtIndex(0) as Task)
            
            
        } else {
            
        }
    }
}