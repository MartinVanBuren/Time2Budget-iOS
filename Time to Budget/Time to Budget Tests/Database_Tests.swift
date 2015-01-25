//
//  Database_Tests.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/25/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import XCTest
import Realm
import Time_to_Budget

class Database_Tests: XCTestCase {
    let defaultRealmPath = RLMRealm.defaultRealmPath()
    let testRealmPath = RLMRealm.defaultRealmPath() + "test"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        RLMRealm.setDefaultRealmPath(testRealmPath)
        Database.getRealm().beginWriteTransaction()
        RLMRealm.defaultRealm().deleteAllObjects()
        Database.getRealm().commitWriteTransaction()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Database.getRealm().beginWriteTransaction()
        RLMRealm.defaultRealm().deleteAllObjects()
        Database.getRealm().commitWriteTransaction()
        RLMRealm.setDefaultRealmPath(defaultRealmPath)
        super.tearDown()
    }

    func test_addCategory() {
        
        Database.addCategory(name: "TestCategory")
        let check = (Category.objectsWhere("name = 'TestCategory'").objectAtIndex(0) as Category)
        
        XCTAssert((check.name == "TestCategory"), "Failed to Add Category")
    }

    func test_addTask() {
        Database.addCategory(name: "TestCategory")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.15, categoryName: "TestCategory")
        
        let task = Task.objectsWhere("name = 'TestTask'").objectAtIndex(0) as Task
        let category = (Category.objectsWhere("name = 'TestCategory'").objectAtIndex(0) as Category).tasks
        
        let categoryCheck:Bool = ((category.objectAtIndex(0) as Task).name == "TestTask")
        let nameCheck:Bool = (task.name == "TestTask")
        let memoCheck:Bool = (task.memo == "TestMemo")
        let timeCheck:Bool = (task.timeRemaining == 5.15)
        
        XCTAssert((nameCheck && memoCheck && timeCheck && categoryCheck), "Failed to Add Task")
    }
    
    func test_moveTask() {
        
        Database.addCategory(name: "Test1")
        Database.addCategory(name: "Test2")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.45, categoryName: "Test1")
        
        let task = Task.objectsWhere("name = 'TestTask'").objectAtIndex(0) as Task
        
        Database.moveTask(task: task, newCategory: "Test2")
        
        let cat1 = Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category
        let cat2 = Category.objectsWhere("name = 'Test2'").objectAtIndex(0) as Category
        
        let moveCheck = (cat1.tasks.count == 0 && cat2.tasks.count == 1 && (cat2.tasks.objectAtIndex(0) as Task).name == "TestTask")
        
        XCTAssert(moveCheck, "Failed to Move Task")
    }
    
    func test_updateTask() {
        
        Database.addCategory(name: "Test1")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.45, categoryName: "Test1")
        let task = Task.objectsWhere("name = 'TestTask'").objectAtIndex(0) as Task
        
        Database.updateTask(task: task, name: "TestTaskUpdated", memo: "TestMemoUpdated", time: 1.15, categoryName: "Test1")
        
        let newTask = (Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category).tasks.objectAtIndex(0) as Task
        
        let moveCheck = ((Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category).tasks.count == 1)
        let nameCheck = (newTask.name == "TestTaskUpdated")
        let memoCheck = (newTask.memo == "TestMemoUpdated")
        let timeCheck = (newTask.timeRemaining == 1.15)
        
        XCTAssert((moveCheck && nameCheck && memoCheck && timeCheck), "Failed to Update Task")
    }
}
