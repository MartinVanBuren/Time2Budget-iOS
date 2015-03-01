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
        
        Database.moveTask(taskName: task.name, newCategoryName: "Test2")
        
        let cat1 = Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category
        let cat2 = Category.objectsWhere("name = 'Test2'").objectAtIndex(0) as Category
        
        let moveCheck = (cat1.tasks.count == 0 && cat2.tasks.count == 1 && (cat2.tasks.objectAtIndex(0) as Task).name == "TestTask")
        
        XCTAssert(moveCheck, "Failed to Move Task")
    }
    
    func test_updateTask() {
        
        Database.addCategory(name: "Test1")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.45, categoryName: "Test1")
        let task = Task.objectsWhere("name = 'TestTask'").objectAtIndex(0) as Task
        
        Database.updateTask(taskName: task.name, name: "TestTaskUpdated", memo: "TestMemoUpdated", time: 1.15, categoryName: "Test1")
        
        let newTask = (Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category).tasks.objectAtIndex(0) as Task
        
        let moveCheck = ((Category.objectsWhere("name = 'Test1'").objectAtIndex(0) as Category).tasks.count == 1)
        let nameCheck = (newTask.name == "TestTaskUpdated")
        let memoCheck = (newTask.memo == "TestMemoUpdated")
        let timeCheck = (newTask.timeRemaining == 1.15)
        
        XCTAssert((moveCheck && nameCheck && memoCheck && timeCheck), "Failed to Update Task")
    }
    
    func test_checkCategoryName() {
        
        let trueTest = Database.checkCategoryName(name: "Test1")
        
        Database.addCategory(name: "Test2")
        
        let falseTest = !Database.checkCategoryName(name: "Test2")
        
        XCTAssert((trueTest && falseTest), "Failed to Detect Name Availability")
    }
    
    func test_checkTaskName() {
        
        let trueTest = Database.checkTaskName(name: "Test1")
        
        Database.addCategory(name: "TestCat")
        Database.addTask(name: "Test2", memo: "", time: 0.0, categoryName: "TestCat")
        
        let falseTest = !Database.checkTaskName(name: "Test2")
        
        XCTAssert((trueTest && falseTest), "Failed to Detect Name Availability")
    }
    
    func test_deleteCategory() {
        Database.addCategory(name: "Test 1")
        Database.addCategory(name: "Test 2")
        Database.addCategory(name: "Uncategorized")
        
        Database.addTask(name: "dtest1", memo: "test", time: 0.0, categoryName: "Test 1")
        Database.addTask(name: "dtest2", memo: "test", time: 0.0, categoryName: "Test 1")
        Database.addTask(name: "dtest3", memo: "test", time: 0.0, categoryName: "Test 1")
        
        Database.addTask(name: "test1", memo: "test", time: 0.0, categoryName: "Test 2")
        Database.addTask(name: "test2", memo: "test", time: 0.0, categoryName: "Test 2")
        Database.addTask(name: "test3", memo: "test", time: 0.0, categoryName: "Test 2")
        
        Database.deleteCategory(categoryName: "Test 1", retainTasks: false)
        Database.deleteCategory(categoryName: "Test 2", retainTasks: true)
        
        let retainedTask1Test = ((Task.objectsWhere("name = 'test1'").objectAtIndex(0) as Task).name == "test1")
        let retainedTask2Test = ((Task.objectsWhere("name = 'test2'").objectAtIndex(0) as Task).name == "test2")
        let retainedTask3Test = ((Task.objectsWhere("name = 'test3'").objectAtIndex(0) as Task).name == "test3")
        
        let deletedTask1Test = (Task.objectsWhere("name = 'dtest1'").count == 0)
        let deletedTask2Test = (Task.objectsWhere("name = 'dtest2'").count == 0)
        let deletedTask3Test = (Task.objectsWhere("name = 'dtest3'").count == 0)
        
        let deletedTest:Bool = (Category.objectsWhere("name = 'Test 1'").count == 0 && Category.objectsWhere("name = 'Test 2'").count == 0)
        let retainedTasksTest = (retainedTask1Test && retainedTask2Test && retainedTask3Test)
        let deletedTasksTest = (deletedTask1Test && deletedTask2Test && deletedTask3Test)
        let tasklessCountTest = ((Category.objectsWhere("name = 'Uncategorized'").objectAtIndex(0) as Category).tasks.count == 3)
        
        XCTAssert((retainedTasksTest && deletedTasksTest && deletedTest), "Failed to Delete Category Properly")
    }
    
    func test_deleteTask() {
        Database.addCategory(name: "Uncategorized")
        Database.addCategory(name: "Test")
        
        Database.addTask(name: "Taskless Records", memo: "", time: 0.0, categoryName: "Uncategorized")
        Database.addTask(name: "Test1", memo: "", time: 0.0, categoryName: "Test")
        Database.addTask(name: "Test2", memo: "", time: 0.0, categoryName: "Test")
        
        Database.addRecord(taskName: "Test1", note: "darn1", timeSpent: 0.0, date: NSDate())
        Database.addRecord(taskName: "Test1", note: "darn2", timeSpent: 0.0, date: NSDate())
        Database.addRecord(taskName: "Test1", note: "darn3", timeSpent: 0.0, date: NSDate())
        
        Database.addRecord(taskName: "Test2", note: "woo1", timeSpent: 0.0, date: NSDate())
        Database.addRecord(taskName: "Test2", note: "woo2", timeSpent: 0.0, date: NSDate())
        Database.addRecord(taskName: "Test2", note: "woo3", timeSpent: 0.0, date: NSDate())
        
        Database.deleteTask(taskName: "Test1", retainRecords: false)
        Database.deleteTask(taskName: "Test2", retainRecords: true)
        
        let tasklessList = (Task.objectsWhere("name = 'Taskless Records'").objectAtIndex(0) as Task).records
        
        let woo1Test = (tasklessList.objectsWhere("note = 'woo1'").objectAtIndex(0) as Record).note == "woo1"
        let woo2Test = (tasklessList.objectsWhere("note = 'woo2'").objectAtIndex(0) as Record).note == "woo2"
        let woo3Test = (tasklessList.objectsWhere("note = 'woo3'").objectAtIndex(0) as Record).note == "woo3"
        
        let darn1Test = (tasklessList.objectsWhere("note = 'darn1'").count == 0)
        let darn2Test = (tasklessList.objectsWhere("note = 'darn2'").count == 0)
        let darn3Test = (tasklessList.objectsWhere("note = 'darn3'").count == 0)
        
        let deletedTest:Bool = (Task.objectsWhere("name = 'Test1'").count == 0 && Task.objectsWhere("name = 'Test2'").count == 0)
        let retainedRecordsTest = (woo1Test && woo2Test && woo3Test)
        let deletedRecordsTest = (darn1Test && darn2Test && darn3Test)
        let tasklessCountTest = (tasklessList.count == 3)
        
        XCTAssert((deletedTest && retainedRecordsTest), "Failed to Delete Task Properly")
    }
    
    func test_addRecord() {
        let testDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        Database.addCategory(name: "TestCat")
        Database.addTask(name: "TestTask", memo: "test", time: 0.0, categoryName: "TestCat")
        Database.addRecord(taskName: "TestTask", note: "testNote", timeSpent: 5.30, date: testDate)
        
        let record = (((Category.objectsWhere("name = 'TestCat'").objectAtIndex(0) as Category).tasks.objectAtIndex(0) as Task).records.objectAtIndex(0) as Record)
        
        let noteTest:Bool = (record.note == "testNote")
        let timeTest:Bool = (record.timeSpent == 5.30)
        let dateTest:Bool = (record.dateToString() == dateFormatter.stringFromDate(testDate))
        
        XCTAssert((noteTest && timeTest && dateTest), "Failed to Add Record Properly")
    }
    
    func test_moveRecord() {
        
        let testDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        Database.addCategory(name: "Test1")
        Database.addCategory(name: "Test2")
        
        Database.addTask(name: "TestTask1", memo: "", time: 0.0, categoryName: "Test1")
        Database.addTask(name: "TestTask2", memo: "", time: 0.0, categoryName: "Test2")
        
        Database.addRecord(taskName: "TestTask1", note: "testNote", timeSpent: 6.45, date: testDate)
        
        let record = (Task.objectsWhere("name = 'TestTask1'").objectAtIndex(0) as Task).records.objectAtIndex(0) as Record
        
        Database.moveRecord(record: record, newTaskName: "TestTask2")
        
        let movedRecord = (Task.objectsWhere("name = 'TestTask2'").objectAtIndex(0) as Task).records.objectAtIndex(0) as Record
        
        let recordRemovedTest:Bool = ((Task.objectsWhere("name = 'TestTask1'").objectAtIndex(0) as Task).records.count == 0)
        let recordAddedTest:Bool = ((Task.objectsWhere("name = 'TestTask2'").objectAtIndex(0) as Task).records.count == 1)
        let recordInfoTest:Bool = (movedRecord.note == "testNote" && movedRecord.timeSpent == 6.45 && movedRecord.dateToString() == dateFormatter.stringFromDate(testDate))

        
        XCTAssert((recordRemovedTest && recordAddedTest && recordInfoTest), "Failed to Move Record Properly")
    }
    
    func test_deleteRecord() {
        Database.addCategory(name: "testCat")
        Database.addTask(name: "test", memo: "", time: 0.0, categoryName: "testCat")
        Database.addRecord(taskName: "test", note: "testNote", timeSpent: 0.0, date: NSDate())
        
        Database.deleteRecord(record: Record.objectsWhere("note = 'testNote'").objectAtIndex(0) as Record)
        
        let deletedTest = (Record.objectsWhere("note = 'testNote'").count == 0)
        let deletedFromTaskTest = ((Task.objectsWhere("name = 'test'").objectAtIndex(0) as Task).records.count == 0)
        
        XCTAssert((deletedTest && deletedFromTaskTest), "Failed to Delete Record Properly")
    }
    
    func test_updateRecord() {
        Database.addCategory(name: "testCat")
        Database.addTask(name: "test", memo: "", time: 0.0, categoryName: "testCat")
        Database.addTask(name: "newTest", memo: "", time: 0.0, categoryName: "testCat")
        Database.addRecord(taskName: "test", note: "testNote", timeSpent: 0.0, date: NSDate())
        
        Database.updateRecord(record: (Task.objectsWhere("name = 'test'").objectAtIndex(0) as Task).records.objectAtIndex(0) as Record, taskName: "newTest", note: "testTestNote", timeSpent: 4.30, date: NSDate())
        
        let movedTest = ((Task.objectsWhere("name = 'newTest'").objectAtIndex(0) as Task).records.count == 1 && (Task.objectsWhere("name = 'test'").objectAtIndex(0) as Task).records.count == 0)
        let noteTest = (((Task.objectsWhere("name = 'newTest'").objectAtIndex(0) as Task).records.objectAtIndex(0) as Record).note == "testTestNote")
        let timeSpentTest = (((Task.objectsWhere("name = 'newTest'").objectAtIndex(0) as Task).records.objectAtIndex(0) as Record).timeSpent == 4.30)
        
        XCTAssert((movedTest && noteTest && timeSpentTest), "Failed to Update Record Properly")
    }
    
    func test_updateCategory() {
        Database.addCategory(name: "TestCat")
        
        Database.updateCategory(categoryName: "TestCat", newCategoryName: "TestCategory")
        
        let updatedTest = (Category.objectsWhere("name = 'TestCategory'").count == 1 && Category.objectsWhere("name = 'TestCat'").count == 0)
        
        XCTAssert(updatedTest, "Failed to Update Category Properly")
    }
}
