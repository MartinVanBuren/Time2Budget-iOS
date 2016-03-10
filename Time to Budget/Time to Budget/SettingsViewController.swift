//
//  SettingsViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UITableViewController {
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nib files for tableView Cells/Headers.
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        // Applies the Time to Budget theme to the navbar and view controller.
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
        
        self.navigationItem.title = "Settings"
    }
    
    //==================== UITableViewDataSource Methods ====================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 3
        case 0:
            return 4
        case 2:
            return 3
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "Database")
        case 1:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "Application")
        case 0:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "About")
        default:
            return UIView()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Enable Tutorial")
            case 1:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Enable Welcome Screen")
            case 2:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "System Settings")
            default:
                return UITableViewCell()
            }
        case 0:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Info")
            case 1:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Feedback")
            case 2:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Blog")
            case 3:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Privacy Policy")
            default:
                return UITableViewCell()
            }
        case 2:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Archive Budget")
            case 1:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Clear Budget History")
            case 2:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Reset All to Default Budget")
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    //==================== UITableViewDelegate Methods ====================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                Factory.displayAlert(viewController: self, title: "Time to Budget", message: "Version 0.9.9\nCopyright © 2015 Arrken Software LLC\nCreated by Robert Kennedy\n\nDatabase - realm/Realm\nTutorial - ephread/Instructions")
            case 1:
                let url = NSURL(string: "https://drive.google.com/open?id=12NlkoJnnjjaXK5Ruc9JV-xGqpk3uHLlHHTOvoiqmQ2U")
                UIApplication.sharedApplication().openURL(url!)
            case 2:
                let url = NSURL(string: "http://robertkennedy.me/blog/")
                UIApplication.sharedApplication().openURL(url!)
            case 3:
                let url = NSURL(string: "https://googledrive.com/host/0ByiIRCNWZES_V2x3eWd6QXYtTjA")
                UIApplication.sharedApplication().openURL(url!)
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                Tutorial.enableTutorials()
                Factory.displayAlert(viewController: self, title: "Tutorial Enabled", message: "The tutorial will now run when you return to the Budget View and Budget Editor.")
            case 1:
                let settings = NSUserDefaults.standardUserDefaults()
                settings.setBool(true, forKey: "showWelcome")
                Factory.displayAlert(viewController: self, title: "Welcome Enabled", message: "The welcome screen will now run when you restart Time to Budget.")
            case 2:
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            default:
                return
            }
        case 2:
            for views in tabBarController!.viewControllers! {
                (views as! UINavigationController).popToRootViewControllerAnimated(false)
            }
            
            switch indexPath.row {
            case 0:
                displayArchiveBudgetAlert()
            case 1:
                displayResetHistoryAlert()
            case 2:
                displayResetToDefaultAlert()
            default:
                return
            }
        default:
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //==================== Helper Methods ====================
    /**
    Displays an alert message asking the user if they are sure they would like to 
    reset the database, and deletes everything in the database and restores the default
    budget if the user agrees.
    
    - Parameter None:
    - returns: Nothing
    */
    func displayResetToDefaultAlert() {
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all information, including archived budgets, and restore the default budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.restoreDefaultBudget()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    /**
     Displays an alert message asking the user if they are sure they would like to
     reset the budget history, and deletes all non-current budgets in the database 
     if the user says yes.
     
     - Parameter None:
     - returns: Nothing
     */
    func displayResetHistoryAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all non-current budgets?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            try! realm.write {
                realm.delete(realm.objects(Budget).filter("isCurrent = FALSE"))
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    /**
     Displays an alert message asking the user if they are sure they would like to
     archive the current budget, and creates a new budget if the user says yes.
     
     - Parameter None:
     - returns: Nothing
     */
    func displayArchiveBudgetAlert() {
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to archive the current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.newBudget()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
}
