import UIKit
import RealmSwift

public class Database {
    // ========== Static Properties ==========
    static var testingEnabled = false
    static var debugEnabled = false
    
    // ==================== Static Methods ====================
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
            
            schemaVersion: 2,
            
            migrationBlock: { migration, oldSchemaVersion in
                
                print(oldSchemaVersion)
                if (oldSchemaVersion < 1) {
                    migration.enumerate(Budget.className(), { oldObject, newObject in
                        // Initalize clock object in Budget
                        newObject?["clock"] = migration.create(Clock.className())
                    })
                    
                    migration.enumerate(Task.className(), { oldObject, newObject in
                        // Initalize clock object in Tasks
                        newObject?["clock"] = migration.create(Clock.className())
                    })
                }
                if (oldSchemaVersion < 2) {
                    
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        Database.getRealm()
    }
    
    public class func restoreDefaultBudget() {
        var realm = getRealm()
        try! realm.write {
            realm.deleteAll()
        }
        
        if (realm.objects(Budget).count == 0) {
            newBudget()
        }
        
        addCategory(name: "Work")
        addCategory(name: "College")
        addCategory(name: "Miscellaneous")
        
        addTask(name: "Day Job", memo: "When your not fighting crime.", time: 20.0, categoryName: "Work")
        addTask(name: "Crime Fighting", memo: "Beating up bad guys.", time: 30.0, categoryName: "Work")
        addTask(name: "Training", memo: "Preparing to beat up bad guys.", time: 10.0, categoryName: "Work")
        addTask(name: "Criminal Justice 376", memo: "Make sure super villains get a thrashing.", time: 8.0, categoryName: "College")
        addTask(name: "Calculus III", memo: "Superheroes love math.", time: 14.0, categoryName: "College")
        addTask(name: "Data Structures & Algorithms", memo: "Superheroes also love computer science. :D", time: 10.0, categoryName: "College")
        addTask(name: "Sleep", memo: "Being unconscious.", time: 56.0, categoryName: "Miscellaneous")
        addTask(name: "Recreation", memo: "Relax and enjoy a nice cup of coffee.", time: 20.0, categoryName: "Miscellaneous")
        
        realm = getRealm()
        let task = realm.objects(Task).filter("name = 'Day Job'").first!
        
        addRecord(parentTask: task, note: "Did some work today.", timeSpent: 5.0, date: NSDate())
    }
    
    public class func getBudget() -> Budget {
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
        
        if debugEnabled {
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
                realm.delete(oldBudget.clock!)
                oldBudget.isCurrent = false
                for cat in oldBudget.categories {
                    for task in cat.tasks {
                        realm.delete(task.clock!)
                    }
                }
            }
        } else {
            try! realm.write {
                let newBudget = Budget()
                newBudget.autoInit()
                realm.add(newBudget)
            }
        }
        
        if debugEnabled {
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
        
        for oldCategory in oldCategories {
            let newCategory = Category()
            
            newCategory.name = oldCategory.name
            newCategory.parent = newBudget
            
            for oldTask in oldCategory.tasks {
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
            
            if debugEnabled {
                let testCategory = realm.objects(Category).filter("name = '\(name)'").first!
                print("addCategory->testCategory.name: ", testCategory.name)
            }
            
        } else {
            if debugEnabled {
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
        
        for task in currentCategoryTasks {
            deleteTask(task: task)
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
        
        if debugEnabled {
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
        
        if debugEnabled {
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
        
        if debugEnabled {
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
        
        if debugEnabled {
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
            
            if debugEnabled {
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
            realm.delete(task.clock!)
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
        
        if debugEnabled {
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
        
        try! realm.write {
            oldTask.records.removeAtIndex(oldIndex)
            oldTask.calcTime()
            record.parent = newTask
            newTask.records.append(record)
            newTask.calcTime()
        }
        
        if debugEnabled {
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
        if debugEnabled {
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
