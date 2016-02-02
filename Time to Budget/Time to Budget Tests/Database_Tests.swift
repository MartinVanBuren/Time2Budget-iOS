//
//  Database_Tests.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/25/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Time_to_Budget

class Database_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "DatabaseTest"
        Database.testingEnabled = true
        
        Database.newBudget()
    }
    
    override func tearDown() {
        super.tearDown()
        
        let realm = Database.getRealm()
        try! realm.write({
            realm.deleteAll()
        })
        Database.testingEnabled = false
        
    }

    func test_addCategory() {
        let realm = Database.getRealm()
        Database.addCategory(name: "TestCategory")
        
        let testCategory = realm.objects(Category.self).filter("name = 'TestCategory'").first!
        
        let result = (testCategory.name == "TestCategory")
        
        XCTAssert(result, "Failed to Add Category")
    }

    func test_addTask() {
        let realm = Database.getRealm()
        Database.addCategory(name: "TestCategory")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.25, categoryName: "TestCategory")
        
        let taskResults = realm.objects(Task.self).filter("name = 'TestTask'")
        let categoryResults = realm.objects(Category.self).filter("name = 'TestCategory'")
        let task = taskResults.first!
        let category = categoryResults.first!
        
        let resultsNumCheck:Bool = (taskResults.count == 1 && categoryResults.count == 1)
        let categoryCheck:Bool = (category.tasks.first!.name == "TestTask")
        let nameCheck:Bool = (task.name == "TestTask")
        let memoCheck:Bool = (task.memo == "TestMemo")
        let timeCheck:Bool = (task.timeRemaining == 5.25)
        
        XCTAssert((nameCheck && memoCheck && timeCheck && categoryCheck && resultsNumCheck), "Failed to Add Task")
    }
    
    func test_moveTask() {
        let realm = Database.getRealm()
        Database.addCategory(name: "Test1")
        Database.addCategory(name: "Test2")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.75, categoryName: "Test1")
        
        let taskResult = realm.objects(Task.self).filter("name = 'TestTask'")
        
        let task = taskResult.first!
        
        Database.moveTask(task: task, newCategoryName: "Test2")
        
        let cat1 = realm.objects(Category.self).filter("name = 'Test1'").first!
        let cat2 = realm.objects(Category.self).filter("name = 'Test2'").first!
        
        let moveCheck = (cat1.tasks.count == 0 && cat2.tasks.count == 1 && cat2.tasks.first!.name == "TestTask")
        
        XCTAssert(moveCheck, "Failed to Move Task")
    }
    
    func test_updateTask() {
        let realm = Database.getRealm()
        Database.addCategory(name: "Test1")
        Database.addTask(name: "TestTask", memo: "TestMemo", time: 5.75, categoryName: "Test1")
        
        let task = realm.objects(Task).filter("name = 'TestTask'").first!
        
        Database.updateTask(task: task, name: "TestTaskUpdated", memo: "TestMemoUpdated", time: 1.25, categoryName: "Test1")
        
        let newTask = realm.objects(Category.self).filter("name = 'Test1'").first!.tasks.first!
        
        let moveCheck = (realm.objects(Category.self).filter("name = 'Test1'").first!.tasks.count == 1)
        let nameCheck = (newTask.name == "TestTaskUpdated")
        let memoCheck = (newTask.memo == "TestMemoUpdated")
        let timeCheck = (newTask.timeRemaining == 1.25)
        
        XCTAssert((moveCheck && nameCheck && memoCheck && timeCheck), "Failed to Update Task")
    }
    
    func test_checkCategoryName() {
        
        let trueTest = Database.checkCategoryName(name: "Test1")
        
        Database.addCategory(name: "Test2")
        
        let falseTest = !Database.checkCategoryName(name: "Test2")
        
        XCTAssert((trueTest && falseTest), "Failed to Detect Name Availability")
    }
    
    func test_deleteCategory() {
        let realm = Database.getRealm()
        
        Database.addCategory(name: "Test 1")
        Database.addCategory(name: "Test 2")
        Database.addCategory(name: "Uncategorized")
        
        Database.addTask(name: "dtest1", memo: "test", time: 0.0, categoryName: "Test 1")
        Database.addTask(name: "dtest2", memo: "test", time: 0.0, categoryName: "Test 1")
        Database.addTask(name: "dtest3", memo: "test", time: 0.0, categoryName: "Test 1")
        
        Database.deleteCategory(categoryName: "Test 1")
        
        let deletedTask1Test = (realm.objects(Task.self).filter("name = 'dtest1'").count == 0)
        let deletedTask2Test = (realm.objects(Task.self).filter("name = 'dtest2'").count == 0)
        let deletedTask3Test = (realm.objects(Task.self).filter("name = 'dtest3'").count == 0)
        
        let deletedTest:Bool = (realm.objects(Category.self).filter("name = 'Test 1'").count == 0 && realm.objects(Category.self).filter("name = 'Test 2'").count == 0)
        let deletedTasksTest = (deletedTask1Test && deletedTask2Test && deletedTask3Test)
        
        XCTAssert((deletedTasksTest && deletedTest), "Failed to Delete Category Properly")
    }
    
    func test_deleteTask() {
        let realm = Database.getRealm()
        
        Database.addCategory(name: "Uncategorized")
        Database.addCategory(name: "Test")
        
        Database.addTask(name: "Taskless Records", memo: "", time: 0.0, categoryName: "Uncategorized")
        Database.addTask(name: "Test1", memo: "", time: 0.0, categoryName: "Test")
        
        let testTask1 = realm.objects(Task).filter("name = 'Test1'").first!
        
        Database.addRecord(parentTask: testTask1, note: "darn1", timeSpent: 0.0, date: NSDate())
        Database.addRecord(parentTask: testTask1, note: "darn2", timeSpent: 0.0, date: NSDate())
        Database.addRecord(parentTask: testTask1, note: "darn3", timeSpent: 0.0, date: NSDate())
        
        Database.deleteTask(task: testTask1)
        
        let tasklessList = realm.objects(Task).filter("name = 'Taskless Records'").first!.records
        
        let darn1Test = (tasklessList.filter("note = 'darn1'").count == 0)
        let darn2Test = (tasklessList.filter("note = 'darn2'").count == 0)
        let darn3Test = (tasklessList.filter("note = 'darn3'").count == 0)
        
        let deletedTest:Bool = (realm.objects(Task).filter("name = 'Test1'").count == 0 && realm.objects(Task).filter("name = 'Test2'").count == 0)
        let deletedRecordsTest = (darn1Test && darn2Test && darn3Test)
        
        XCTAssert((deletedTest && deletedRecordsTest), "Failed to Delete Task Properly")
    }
    
    func test_addRecord() {
        let realm = Database.getRealm()
        let testDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        Database.addCategory(name: "TestCat")
        Database.addTask(name: "TestTask", memo: "test", time: 0.0, categoryName: "TestCat")
        let testTask = realm.objects(Task).filter("name = 'TestTask'").first!
        Database.addRecord(parentTask: testTask, note: "testNote", timeSpent: 5.50, date: testDate)
        
        let record = realm.objects(Category.self).filter("name = 'TestCat'").first!.tasks.first!.records.first!
        
        let noteTest:Bool = (record.note == "testNote")
        let timeTest:Bool = (record.timeSpent == 5.50)
        let dateTest:Bool = (record.dateToString() == dateFormatter.stringFromDate(testDate))
        
        XCTAssert((noteTest && timeTest && dateTest), "Failed to Add Record Properly")
    }
    
    func test_moveRecord() {
        let realm = Database.getRealm()
        let testDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        Database.addCategory(name: "Test1")
        Database.addCategory(name: "Test2")
        
        Database.addTask(name: "TestTask1", memo: "", time: 0.0, categoryName: "Test1")
        Database.addTask(name: "TestTask2", memo: "", time: 0.0, categoryName: "Test2")
        let testTask1 = realm.objects(Task).filter("name = 'TestTask1'").first!
        let testTask2 = realm.objects(Task).filter("name = TestTask2").first!
        
        Database.addRecord(parentTask: testTask1, note: "testNote", timeSpent: 6.75, date: testDate)
        
        let record = realm.objects(Task).filter("name = 'TestTask1'").first!.records.first!
        
        Database.moveRecord(record: record, newTask: testTask2)
        
        let movedRecord = realm.objects(Task).filter("name = 'TestTask2'").first!.records.first!
        
        let recordRemovedTest:Bool = (realm.objects(Task).filter("name = 'TestTask1'").first!.records.count == 0)
        let recordAddedTest:Bool = (realm.objects(Task).filter("name = 'TestTask2'").first!.records.count == 1)
        let recordInfoTest:Bool = (movedRecord.note == "testNote" && movedRecord.timeSpent == 6.75 && movedRecord.dateToString() == dateFormatter.stringFromDate(testDate))

        
        XCTAssert((recordRemovedTest && recordAddedTest && recordInfoTest), "Failed to Move Record Properly")
    }
    
    func test_deleteRecord() {
        let realm = Database.getRealm()
        Database.addCategory(name: "testCat")
        Database.addTask(name: "test", memo: "", time: 0.0, categoryName: "testCat")
        let testTask = realm.objects(Task).filter("name = 'test'").first!
        Database.addRecord(parentTask: testTask, note: "testNote", timeSpent: 0.0, date: NSDate())
        
        Database.deleteRecord(record: realm.objects(Record).filter("note = 'testNote'").first!)
        
        let deletedTest = (realm.objects(Record).filter("note = 'testNote'").count == 0)
        let deletedFromTaskTest = (realm.objects(Task).filter("name = 'test'").first!.records.count == 0)
        
        XCTAssert((deletedTest && deletedFromTaskTest), "Failed to Delete Record Properly")
    }
    
    func test_updateRecord() {
        let realm = Database.getRealm()
        Database.addCategory(name: "testCat")
        Database.addTask(name: "test", memo: "", time: 0.0, categoryName: "testCat")
        Database.addTask(name: "newTest", memo: "", time: 0.0, categoryName: "testCat")
        let testTask = realm.objects(Task).filter("name = 'test'").first!
        let newTask = realm.objects(Task).filter("name = newTask").first!
        Database.addRecord(parentTask: testTask, note: "testNote", timeSpent: 0.0, date: NSDate())
        
        Database.updateRecord(record: realm.objects(Task).filter("name = 'test'").first!.records.first!, task: newTask, note: "testTestNote", timeSpent: 4.50, date: NSDate())
        
        let movedTest = (realm.objects(Task).filter("name = 'newTest'").first!.records.count == 1 && realm.objects(Task).filter("name = 'test'").first!.records.count == 0)
        let noteTest = (realm.objects(Task).filter("name = 'newTest'").first!.records.first!.note == "testTestNote")
        let timeSpentTest = (realm.objects(Task).filter("name = 'newTest'").first!.records.first!.timeSpent == 4.50)
        
        XCTAssert((movedTest && noteTest && timeSpentTest), "Failed to Update Record Properly")
    }
    
    func test_updateCategory() {
        let realm = Database.getRealm()
        Database.addCategory(name: "TestCat")
        
        Database.updateCategory(categoryName: "TestCat", newCategoryName: "TestCategory")
        
        let updatedTest = (realm.objects(Category.self).filter("name = 'TestCategory'").count == 1 && realm.objects(Category.self).filter("name = 'TestCat'").count == 0)
        
        XCTAssert(updatedTest, "Failed to Update Category Properly")
    }
}
