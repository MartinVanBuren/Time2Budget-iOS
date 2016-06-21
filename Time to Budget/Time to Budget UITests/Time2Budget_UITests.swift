import XCTest

class Time2Budget_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        app.tables.staticTexts["Reset All"].tap()
        app.alerts["Are You Sure?"].collectionViews.buttons["Yes"].tap()
        super.tearDown()
    }
    
    func test_addCategory() {
        let app = XCUIApplication()
        
        self.addCategory()
        
        let addCategoryTest = app.tables.staticTexts[""].exists
        XCTAssert(addCategoryTest)
    }
    
    func test_addTask() {
        let app = XCUIApplication()
        
        self.addCategory()
        self.addTask()
        
        let taskTitleTest = app.tables.staticTexts["Test"].exists
        let taskSubtitleTest = app.tables.staticTexts["This is a test."].exists
        let taskTimeTest = app.tables.staticTexts["2:45"].exists
        
        let finalTest = (taskTitleTest && taskSubtitleTest && taskTimeTest)
        
        XCTAssert(finalTest)
    }
    
    func test_addRecord() {
        let app = XCUIApplication()
        
        self.addCategory()
        self.addTask()
        self.addRecord()
        
        let recTimeTest = app.tables.staticTexts["2:45"].exists
        app.navigationBars["Test"].buttons["Budget"].tap()
        let taskTimeTest = app.tables.staticTexts["00:00"].exists
        let finalTest = (recTimeTest && taskTimeTest)
        
        XCTAssert(finalTest)
    }
    
    func test_deleteCategory() {
        let app = XCUIApplication()
        self.addCategory()
        let addedTest = app.tables.staticTexts[""].exists
        
        app.tables.buttons["Edit"].tap()
        app.alerts["Edit Category"].collectionViews.buttons["Delete"].tap()
        app.alerts["Are You Sure?"].collectionViews.buttons["Yes"].tap()
        let deletedTest = !app.tables.staticTexts[""].exists
        
        let finalTest = (addedTest && deletedTest)
        
        XCTAssert(finalTest)
    }
    
    func test_deleteCategoryNoKeep() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        let addedTest = app.tables.staticTexts[""].exists
        
        app.tables.buttons["Edit"].tap()
        app.alerts["Edit Category"].collectionViews.buttons["Delete"].tap()
        app.alerts["Keep Tasks?"].collectionViews.buttons["No"].tap()
        let deletedTest = !app.tables.staticTexts[""].exists
        
        let finalTest = (addedTest && deletedTest)
        
        XCTAssert(finalTest)
    }
    
    func test_deleteCategoryYesKeep() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        let addedTest = app.tables.staticTexts[""].exists
        
        app.tables.buttons["Edit"].tap()
        app.alerts["Edit Category"].collectionViews.buttons["Delete"].tap()
        app.alerts["Keep Tasks?"].collectionViews.buttons["Yes"].tap()
        let keptTest = app.tables.staticTexts["Uncategorized"].exists
        
        let finalTest = (addedTest && keptTest)
        
        XCTAssert(finalTest)
    }
    
    func test_deleteTask() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        let addedTest = app.tables.staticTexts["Test"].exists
        
        app.tables.cells.staticTexts["Test"].swipeLeft()
        app.tables.cells.buttons["Delete"].tap()
        app.alerts["Are You Sure?"].collectionViews.buttons["Yes"].tap()
        let deletedTest = !app.tables.staticTexts["Test"].exists
        
        let finalTest = (addedTest && deletedTest)
        
        XCTAssert(finalTest)
    }
    
    func test_deleteTaskNoKeep() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        self.addRecord()
        
        app.tabBars.buttons["Editor"].tap()
        
        app.tables.cells.staticTexts["Test"].swipeLeft()
        app.tables.cells.buttons["Delete"].tap()
        app.alerts["Keep Records?"].collectionViews.buttons["No"].tap()
        
        let deleteTest = !app.tables.cells.staticTexts["Test"].exists
        
        XCTAssert(deleteTest)
    }
    
    func test_deleteTaskYesKeep() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        self.addRecord()
        
        app.tabBars.buttons["Editor"].tap()
        
        app.tables.cells.staticTexts["Test"].swipeLeft()
        app.tables.cells.buttons["Delete"].tap()
        app.alerts["Keep Records?"].collectionViews.buttons["Yes"].tap()
        
        let deleteTest = app.tables.cells.staticTexts["Taskless Records"].exists
        
        XCTAssert(deleteTest)
    }
    
    func test_deleteRecord() {
        let app = XCUIApplication()
        self.addCategory()
        self.addTask()
        self.addRecord()
        
        app.tables.cells.staticTexts["This is a test record."].swipeLeft()
        app.tables.cells.buttons["Delete"].tap()
        app.alerts["Are You Sure?"].collectionViews.buttons["Yes"].tap()
        
        let deleteTest = !app.tables.cells.staticTexts["This is a test record."].exists
        
        XCTAssert(deleteTest)
    }
    
    // ========================== Helper Functions ==========================
    
    func addCategory() {
        let app = XCUIApplication()
        app.tabBars.buttons["Editor"].tap()
        app.navigationBars["168:00"].buttons["+ Category"].tap()
        app.alerts["New Category"].collectionViews.buttons["Add"].tap()
    }
    
    func addTask(taskName: String = "Test", taskMemo: String = "This is a test.", taskHrs: String = "2", taskMins: String = "45") {
        let app = XCUIApplication()
        app.tabBars.buttons["Editor"].tap()
        
        app.navigationBars.buttons["+ Task"].tap()
        
        app.tables.textFields["Name (Required)"].tap()
        app.tables.textFields["Name (Required)"].typeText(taskName)
        
        app.tables.textFields["Memo (Optional)"].tap()
        app.tables.textFields["Memo (Optional)"].typeText(taskMemo)
        
        app.tables.staticTexts["Category"].tap()
        app.tables.staticTexts["00:00"].tap()
        
        app.tables.staticTexts["Time Budgeted"].tap()
        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue(taskHrs)
        app.pickerWheels.elementBoundByIndex(1).adjustToPickerWheelValue(taskMins)
        app.buttons["Done"].tap()
        
        app.buttons["Save Task"].tap()
    }
    
    func addRecord(recMemo: String = "This is a test record.", recHrs: String = "2", recMins: String = "45") {
        let app = XCUIApplication()
        
        app.tabBars.buttons["Budget"].tap()
        app.tables.staticTexts["Test"].tap()
        app.navigationBars["Test"].buttons["+ Record"].tap()
        
        app.tables.textFields["Memo (Optional)"].tap()
        app.tables.textFields["Memo (Optional)"].typeText(recMemo)
        
        app.tables.staticTexts["Time Spent"].tap()
        app.pickerWheels.elementBoundByIndex(0).adjustToPickerWheelValue(recHrs)
        app.pickerWheels.elementBoundByIndex(1).adjustToPickerWheelValue(recMins)
        app.buttons["Done"].tap()
        
        app.buttons["Save Record"].tap()
    }
    
}
