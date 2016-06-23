import UIKit

class AlertFactory {
    
    func displayDeleteTaskAlert(viewController viewController: BudgetEditorViewController, indexPath: NSIndexPath) {
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
    
    func displayDeleteCategoryAlert(viewController viewController: BudgetEditorViewController, categoryName: String) {
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
    
    func displayDeleteCategoryAlert(viewController viewController: TaskEditorViewController, categoryName: String) {
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
    
    func displayAddCategoryAlert(viewController viewController: BudgetEditorViewController) {
        var inputTextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text!)) {
                Database.addCategory(name: inputTextField.text!)
                viewController.tableView.reloadData()
            } else {
                self.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'There is another category that uses this name.")
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

    func displayAddCategoryAlert(viewController viewController: TaskEditorCategorySelectorViewController) {
        var inputTextField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if (Database.checkCategoryName(name: inputTextField.text!)) {
                Database.addCategory(name: inputTextField.text!)
                viewController.tableView.reloadData()
            } else {
                self.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'There is another category that uses this name.")
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

    func displayEditCategoryAlert(viewController viewController: BudgetEditorViewController, categoryName: String) {
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
                self.displayAlert(viewController: viewController, title: "Category Name Taken", message: "'\(inputTextField.text)' is already a Category")
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
            self.displayDeleteCategoryAlert(viewController: viewController, categoryName: category.name)
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

    func displayDeleteRecordAlert(viewController: RecordsViewController, record: Record) {
        
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.deleteRecord(record: record)
            viewController.reloadRecords()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }

    func displayAlert(viewController viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: {})
    }
    
}