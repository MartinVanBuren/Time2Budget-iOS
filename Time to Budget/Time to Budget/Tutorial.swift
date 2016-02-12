//
//  Tutorial.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/11/16.
//  Copyright © 2016 Arrken Software, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

public class Tutorial {
    static public var budgetViewPOI = [UIView?](count: 5, repeatedValue: UIView())
    static public var budgetEditorPOI = [UIView?](count: 5, repeatedValue: UIView())
    static public var addRecordPOI = [UIView?](count: 0, repeatedValue: UIView())
    static public var addTaskPOI = [UIView?](count: 0, repeatedValue: UIView())
    
    class func enableTutorials() {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(true, forKey: "showTutorialBudgetView")
        settings.setBool(true, forKey: "showTutorialBudgetEditor")
    }
    
    class func disableTutorials() {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(false, forKey: "showTutorialBudgetView")
        settings.setBool(false, forKey: "showTutorialBudgetEditor")
    }
    
    class func shouldRun(budgetView budgetView:Bool = false, budgetEditor:Bool = false) -> Bool {
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
        }
        
        return false
    }
    
    private class func didRun(budgetView budgetView:Bool = false, budgetEditor:Bool = false) {
        let settings = NSUserDefaults.standardUserDefaults()
        
        if budgetView {
            settings.setBool(false, forKey: "showTutorialBudgetView")
        } else if budgetEditor {
            settings.setBool(false, forKey: "showTutorialBudgetEditor")
        }
    }
    
    class func getHintLabelForIndex(index: Int, budgetView:Bool = false, budgetEditor:Bool = false) -> String {
        if budgetView {
            return budgetViewHintLabels(index)
        } else if budgetEditor {
            return budgetEditorHintLabels(index)
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
            return "The Budget View lets you both record time spent on tasks and view time remaining."
        case 1:
            return "Categories contain Tasks and total how much time you have left to spend for all Tasks under it."
        case 2:
            return "Tasks contain Records and display how much time you have left to spend per Task."
        case 3:
            return "You can record time spent here!"
        case 4:
            return "Or you can record time spent more easily by clocking in and out. :D"
        default:
            return "Oops too many coach mark calls!"
        }
    }
    
    private class func budgetEditorHintLabels(index: Int) -> String {
        switch(index) {
        case 0:
            return "The Budget Editor allows you to modify your Categories and Tasks and displays how much time is unused per week here."
        case 1:
            return "Edit Categories by pressing on them."
        case 2:
            return "Edit Tasks by pressing on them."
        case 3:
            return "Add a new Category here."
        case 4:
            return "Add a new Task here."
        default:
            return "Oops too many coach mark calls!"
        }
    }
}