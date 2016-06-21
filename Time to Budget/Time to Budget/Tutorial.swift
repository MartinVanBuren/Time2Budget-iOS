import UIKit
import RealmSwift
import Instructions

public class Tutorial {
    static public var budgetViewPOI = [UIView?](count: 5, repeatedValue: UIView())
    static public var budgetEditorPOI = [UIView?](count: 6, repeatedValue: UIView())
    static public var recordsViewPOI = [UIView?](count: 5, repeatedValue: UIView())
    static public var addRecordPOI = [UIView?](count: 2, repeatedValue: UIView())
    static public var addTaskPOI = [UIView?](count: 2, repeatedValue: UIView())
    
    class func enableTutorials() {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(true, forKey: "showTutorialBudgetView")
        settings.setBool(true, forKey: "showTutorialBudgetEditor")
        settings.setBool(true, forKey: "showTutorialRecordsView")
        settings.setBool(true, forKey: "showTutorialAddRecordView")
        settings.setBool(true, forKey: "showTutorialAddTaskView")
    }
    
    class func disableTutorials() {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(false, forKey: "showTutorialBudgetView")
        settings.setBool(false, forKey: "showTutorialBudgetEditor")
        settings.setBool(false, forKey: "showTutorialRecordsView")
        settings.setBool(false, forKey: "showTutorialAddRecordView")
        settings.setBool(false, forKey: "showTutorialAddTaskView")
    }
    
    class func shouldRun(budgetView budgetView: Bool = false,
                                    budgetEditor: Bool = false,
                                    recordsView: Bool = false,
                                    addRecordView: Bool = false,
                                    addTaskView: Bool = false) -> Bool {
        let settings = NSUserDefaults.standardUserDefaults()
        
        if budgetView {
            if settings.objectForKey("showTutorialBudgetView") != nil {
                if settings.boolForKey("showTutorialBudgetView") {
                    self.didRun(budgetView: true)
                    return true
                }
            }
        } else if budgetEditor {
            if settings.objectForKey("showTutorialBudgetEditor") != nil {
                if settings.boolForKey("showTutorialBudgetEditor") {
                    self.didRun(budgetEditor: true)
                    return true
                }
            }
        } else if recordsView {
            if (settings.objectForKey("showTutorialRecordsView") != nil) {
                if settings.boolForKey("showTutorialRecordsView") {
                    self.didRun(recordsView: true)
                    return true
                }
            }
        } else if addRecordView {
            if (settings.objectForKey("showTutorialAddRecordView") != nil) {
                if settings.boolForKey("showTutorialAddRecordView") {
                    self.didRun(addRecordView: true)
                    return true
                }
            }
        } else if addTaskView {
            if (settings.objectForKey("showTutorialAddTaskView") != nil) {
                if settings.boolForKey("showTutorialAddTaskView") {
                    self.didRun(addTaskView: true)
                    return true
                }
            }
        }
        
        return false
    }
    
    private class func didRun(budgetView budgetView: Bool = false,
                                         budgetEditor: Bool = false,
                                         recordsView: Bool = false,
                                         addRecordView: Bool = false,
                                         addTaskView: Bool = false) {
        let settings = NSUserDefaults.standardUserDefaults()
        
        if budgetView {
            settings.setBool(false, forKey: "showTutorialBudgetView")
        } else if budgetEditor {
            settings.setBool(false, forKey: "showTutorialBudgetEditor")
        } else if recordsView {
            settings.setBool(false, forKey: "showTutorialRecordsView")
        } else if addRecordView {
            settings.setBool(false, forKey: "showTutorialAddRecordView")
        } else if addTaskView {
            settings.setBool(false, forKey: "showTutorialAddTaskView")
        }
    }
    
    class func getHintLabelForIndex(index: Int,
                                    budgetView: Bool = false,
                                    budgetEditor: Bool = false,
                                    recordsView: Bool = false,
                                    addRecordView: Bool = false,
                                    addTaskView: Bool = false) -> String {
        if budgetView {
            return budgetViewHintLabels(index)
        } else if budgetEditor {
            return budgetEditorHintLabels(index)
        } else if recordsView {
            return recordsViewHintLabels(index)
        } else if addRecordView {
            return addRecordViewHintLabels(index)
        } else if addTaskView {
            return addTaskViewHintLabels(index)
        } else {
            return "Oops there aren't any labels for this view yet!"
        }
    }
    
    class func getNextLabel() -> String {
        return "Ok!"
    }
    
    private class func budgetViewHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "The Budget View is for recording time spent."
        case 1:
            return "Categories display the total amount of time you have left to spend for all Tasks under it."
        case 2:
            return "Tasks display how much time you have left to spend."
        case 3:
            return "Record time spent here."
        case 4:
            return "Or record time by clocking in and out. :D"
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
    private class func budgetEditorHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "The Budget Editor is used to add/edit Categories and Tasks."
        case 1:
            return "Edit Categories by pressing on them."
        case 2:
            return "Edit Tasks by pressing on them."
        case 3:
            return "Move Tasks by dragging them."
        case 4:
            return "Add a new Category here."
        case 5:
            return "Add a new Task here."
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
    private class func recordsViewHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "This screen lets you view, edit, or add records under any Task."
        case 1:
            return "Records contain information on time you have spent doing a Task."
        case 2:
            return "Edit records by pressing them."
        case 3:
            return "Add new records here."
        case 4:
            return "Or clock in to this task here. Each task has it's own time clock."
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
    private class func addRecordViewHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "Select the task this Record is for from this list."
        case 1:
            return "Or you can add a new Task here."
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
    private class func addTaskViewHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "Select the Category this Task is for from this list."
        case 1:
            return "Or you can add a new Category here."
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
}
