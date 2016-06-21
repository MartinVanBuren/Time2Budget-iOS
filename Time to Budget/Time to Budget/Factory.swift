import UIKit
import RealmSwift

public class Factory {

    class func prepareCategoryCell(tableView tableView: UITableView, categoryList: List<Category>, section: Int) -> CategoryCell {
        
        let thisCategory = categoryList[section]
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as? CategoryCell {
            preparedCell.customContentView.backgroundColor = UIColor.clearColor()
            preparedCell.backgroundColor = UIColor.clearColor()
            
            preparedCell.sectionNameLabel.text = thisCategory.name
            
            preparedCell.remainingTimeBarOutline.layer.cornerRadius = 60/8
            preparedCell.remainingTimeBar.layer.cornerRadius = 60/8
            preparedCell.remainingTimeBarOutline.layer.masksToBounds = true
            preparedCell.remainingTimeBar.layer.masksToBounds = true
            preparedCell.remainingTimeBarOutline.layer.borderWidth = 1.0
            preparedCell.remainingTimeBarOutline.layer.borderColor = UIColor.greenColor().CGColor
            
            preparedCell.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeRemaining).toString()
            
            preparedCell.category = thisCategory
            
            Style.category(preparedCell)
            
            return preparedCell
        } else {
            return CategoryCell()
        }
        
    }

    class func prepareCategoryView(tableView tableView: UITableView, categoryList: List<Category>, section: Int, editorViewController: BudgetEditorViewController?=nil) -> CategoryView {
        
        let thisCategory = categoryList[section]
        var editor = false
        
        if let preparedView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CategoryView") as? CategoryView {
            if let unwrappedVC = editorViewController {
                preparedView.VC = unwrappedVC
                preparedView.editButton.enabled = true
                preparedView.editButton.hidden = false
                editor = true
            } else {
                preparedView.editButton.enabled = false
                preparedView.editButton.hidden = true
            }
            
            if editor {
                preparedView.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeBudgeted).toString()
            } else {
                preparedView.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeRemaining).toString()
            }
            
            preparedView.sectionNameLabel.text = thisCategory.name
            
            preparedView.category = thisCategory
            preparedView.editor = editor
            
            Style.category(preparedView)
            
            return preparedView
        } else {
            return CategoryView()
        }
        
    }
    
    class func prepareTaskCell(tableView tableView: UITableView, categoryList: List<Category>, indexPath: NSIndexPath, editor: Bool) -> UITableViewCell {
        
        let thisTask = categoryList[indexPath.section].tasks[indexPath.row]
        
        if thisTask.memo == "" {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
                preparedCell.title.text = thisTask.name
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                if editor {
                    preparedCell.detail.text = Time(newTime: thisTask.timeBudgeted).toString()
                } else {
                    preparedCell.detail.text = Time(newTime: thisTask.timeRemaining).toString()
                }
                
                preparedCell.task = thisTask
                preparedCell.editor = editor
                
                Style.task(preparedCell)
                
                return preparedCell
            } else {
                return DetailCell()
            }
        } else {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("SubtitleDetailCell") as? SubtitleDetailCell {
                preparedCell.title.text = thisTask.name
                preparedCell.subtitle.text = thisTask.memo
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                if editor {
                    preparedCell.detail.text = Time(newTime: thisTask.timeBudgeted).toString()
                } else {
                    preparedCell.detail.text = Time(newTime: thisTask.timeRemaining).toString()
                }
                
                preparedCell.task = thisTask
                preparedCell.editor = editor
                
                Style.task(preparedCell)
                
                return preparedCell
            } else {
                return SubtitleDetailCell()
            }
        }
    }
    
    class func prepareAddRecordTaskCell(tableView tableView: UITableView, currentTask: Task?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Task"
            
            if let unwrappedTaskName = currentTask?.name {
                preparedCell.detail.text = unwrappedTaskName
            } else {
                preparedCell.detail.text = "Choose a Task"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    class func prepareAddRecordTimeCell(tableView tableView: UITableView, timeSpent: Time?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Time Spent"
            
            if let unwrappedTimeSpent = timeSpent?.toDouble() {
                preparedCell.detail.text = Time(newTime: unwrappedTimeSpent).toString()
            } else {
                preparedCell.detail.text = "00:00"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    class func prepareAddRecordDateCell(tableView tableView: UITableView, date: NSDate?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Date"
            
            if let unwrappedDate = date {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                
                preparedCell.detail.text = dateFormatter.stringFromDate(unwrappedDate)
            } else {
                preparedCell.detail.text = "Current Date"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    class func prepareNameTextfieldCell(tableView tableView: UITableView, name: String?) -> NameTextfieldCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("NameTextfieldCell") as? NameTextfieldCell {
            if let unwrappedName = name {
                preparedCell.textField.text = unwrappedName
            } else {
                preparedCell.textField.placeholder = "Name (Required)"
            }
            
            preparedCell.selectionStyle = .None
            
            Style.textfieldCell(preparedCell)
            
            return preparedCell
        } else {
            return NameTextfieldCell()
        }
        
    }
    
    class func prepareMemoTextfieldCell(tableView tableView: UITableView, memo: String?) -> MemoTextfieldCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("MemoTextfieldCell") as? MemoTextfieldCell {
            if let unwrappedMemo = memo {
                preparedCell.textField.text = unwrappedMemo
            } else {
                preparedCell.textField.placeholder = "Description (Optional)"
            }
            
            preparedCell.selectionStyle = .None
            
            Style.textfieldCell(preparedCell)
            
            return preparedCell
        } else {
            return MemoTextfieldCell()
        }
        
    }
    
    class func prepareAddTaskCategoryCell(tableView tableView: UITableView, categoryName: String?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Category"
            
            if let unwrappedCategoryName = categoryName {
                preparedCell.detail.text = unwrappedCategoryName
            } else {
                preparedCell.detail.text = "Choose Category"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    class func prepareAddTaskTimeCell(tableView tableView: UITableView, time: Double?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Time Budgeted"
            
            if let unwrappedTime = time {
                preparedCell.detail.text = Time(newTime: unwrappedTime).toString()
            } else {
                preparedCell.detail.text = "00:00"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    class func prepareRecordCell(tableView tableView: UITableView, recordList: List<Record>, indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisRecord = recordList[indexPath.row]
        
        if thisRecord.note == "" {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
                preparedCell.title.text = thisRecord.dateToString()
                preparedCell.detail.text = Time(newTime: thisRecord.timeSpent).toString()
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                Style.record(preparedCell)
                
                return preparedCell
            } else {
                return DetailCell()
            }
            
        } else {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("SubtitleDetailCell") as? SubtitleDetailCell {
                preparedCell.title.text = thisRecord.note
                preparedCell.subtitle.text = thisRecord.dateToString()
                preparedCell.detail.text = Time(newTime: thisRecord.timeSpent).toString()
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                Style.record(preparedCell)
                
                return preparedCell
            } else {
                return SubtitleDetailCell()
            }
            
        }
    }
    
    class func prepareTimeHourPickerData() -> [Int] {
        var finalValue: [Int] = []
        
        for i in 0...99 {
            finalValue.append(i)
        }
        
        return finalValue
    }
    
    class func prepareTimeMinutePickerData() -> [Int] {
        var finalValue: [Int] = []
        
        for i in 0...3 {
            finalValue.append(i * 15)
        }
        
        return finalValue
    }
    
    class func prepareCategoryPickerData(categoryList: Results<Category>) -> [String] {
        var finalData: [String] = []
        
        for category in categoryList {
            finalData.append(category.name)
        }
        
        return finalData
    }
    
    class func prepareBasicCell(tableView tableView: UITableView, titleText: String) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "BasicCell")
        
        preparedCell.textLabel?.text = titleText
        preparedCell.textLabel?.textColor = UIColor.whiteColor()
        preparedCell.backgroundColor = UIColor.clearColor()
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    class func prepareBasicHeader(tableView tableView: UITableView, titleText: String) -> UIView {
        
        if let preparedView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CategoryView") as? CategoryView {
            preparedView.sectionNameLabel.text = titleText
            preparedView.remainingTimeLabel.hidden = true
            preparedView.editButton.enabled = false
            Style.basicHeader(preparedView)
            
            return preparedView
        } else {
            return CategoryView()
        }
        
    }

    class func displayDeleteTaskAlert(viewController viewController: BudgetEditorViewController, indexPath: NSIndexPath) {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories[indexPath.section]
        let currentTask = currentCategory.tasks[indexPath.row]
        
        let alert = UIAlertController(title: "Are You Sure?", message: "This will also delete any Records under this Task!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteTask(task: currentTask)
            viewController.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteCategoryAlert(viewController viewController: BudgetEditorViewController, categoryName: String) {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        let alert = UIAlertController(title: "Are You Sure?", message: "This will also delete any Tasks/Records under this Category!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteCategory(categoryName: currentCategory.name)
            viewController.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteCategoryAlert(viewController viewController: TaskEditorViewController, categoryName: String) {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let currentCategory = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        let alert = UIAlertController(title: "Are You Sure?", message: "This will also delete any Tasks/Records under this Category!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteCategory(categoryName: currentCategory.name)
            viewController.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }

    class func displayAddCategoryAlert(viewController viewController: BudgetEditorViewController) {
        var inputTextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text!)) {
                Database.addCategory(name: inputTextField.text!)
                viewController.tableView.reloadData()
            } else {
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'There is another category that uses this name.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
            inputTextField.placeholder = "Enter Category Name"
            inputTextField.autocapitalizationType = UITextAutocapitalizationType.Words
            inputTextField.keyboardAppearance = UIKeyboardAppearance.Dark
            inputTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        }
        
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayAddCategoryAlert(viewController viewController: TaskEditorCategorySelectorViewController) {
        var inputTextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text!)) {
                Database.addCategory(name: inputTextField.text!)
                viewController.tableView.reloadData()
            } else {
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'There is another category that uses this name.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
            inputTextField.placeholder = "Enter Category Name"
            inputTextField.autocapitalizationType = UITextAutocapitalizationType.Words
            inputTextField.keyboardAppearance = UIKeyboardAppearance.Dark
            inputTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        }
        
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayEditCategoryAlert(viewController viewController: BudgetEditorViewController, categoryName: String) {
        let realm = Database.getRealm()
        let currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        var inputTextField = UITextField()
        let category = currentBudget.categories.filter("name = '\(categoryName)'").first!
        
        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text!) || category.name == inputTextField.text) {
                Database.updateCategory(categoryName: category.name, newCategoryName: inputTextField.text!)
                viewController.tableView.reloadData()
            } else {
                Factory.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
            }
        }))
        alert.addAction(UIAlertAction(title: "Move Up", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let category = currentBudget.categories.filter("name = '\(categoryName)'").first!
            let index = currentBudget.categories.indexOf(category)!
            if (index > 0) {
                Database.moveCategory(categoryName: categoryName, index: (index - 1))
                viewController.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Move Down", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let category = currentBudget.categories.filter("name = '\(categoryName)'").first!
            let index = currentBudget.categories.indexOf(category)!
            let length = currentBudget.categories.count
            if (index < (length - 1)) {
                Database.moveCategory(categoryName: categoryName, index: (index + 1))
                viewController.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Factory.displayDeleteCategoryAlert(viewController: viewController, categoryName: category.name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
            inputTextField.text = category.name
            inputTextField.autocapitalizationType = UITextAutocapitalizationType.Words
            inputTextField.keyboardAppearance = UIKeyboardAppearance.Dark
            inputTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        }
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayDeleteRecordAlert(viewController: UIViewController, record: Record) {
        
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteRecord(record: record)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func displayAlert(viewController viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
    class func archiveBudgetNotification() -> UILocalNotification {
        let realm = Database.getRealm()
        let thisBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let localNotif = UILocalNotification()
        
        localNotif.alertTitle = "Budget Archived"
        localNotif.alertBody = "Your fresh budget is ready!"
        localNotif.fireDate = thisBudget.endDate
        
        return localNotif
    }
    
}
