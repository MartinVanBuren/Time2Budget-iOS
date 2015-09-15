//
//  SettingsViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)
        
        self.navigationItem.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "Reset Budget Info")
        case 1:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "About")
        default:
            return UIView()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Reset All")
            case 1:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Reset Budget History")
            case 2:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Reset Current Budget")
            case 3:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Reset Current Records")
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Feedback")
            case 1:
                return Factory.prepareSettingsAboutCell(tableView: self.tableView)
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let realm = Database.getRealm()
            for views in tabBarController!.viewControllers! {
                (views as! UINavigationController).popToRootViewControllerAnimated(false)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            switch indexPath.row {
            case 0:
                displayResetAllAlert()
            case 1:
                displayResetHistoryAlert()
            case 2:
                displayResetCurrentBudgetAlert()
            case 3:
                displayResetCurrentRecordsAlert()
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                let url = NSURL(string: "https://bitbucket.org/arrkensoftware/timetobudget_ios/issues")
                UIApplication.sharedApplication().openURL(url!)
            case 1:
                let url = NSURL(string: "https://arrken.com")
                UIApplication.sharedApplication().openURL(url!)
            default:
                return
            }
        default:
            return
        }
    }
    
    func displayResetAllAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all information?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            realm.commitWriteTransaction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func displayResetHistoryAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all non-current budgets?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            realm.beginWriteTransaction()
            realm.deleteObjects(Budget.objectsWhere("isCurrent = FALSE"))
            realm.commitWriteTransaction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func displayResetCurrentBudgetAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase the entire current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as! Budget
            for var i:UInt = 0; i < currentBudget.categories.count; i++ {
                let currentCategory = currentBudget.categories[i] as! Category
                for var x:UInt = 0; x < currentCategory.tasks.count; x++ {
                    let currentTask = currentCategory.tasks[x] as! Task
                    realm.beginWriteTransaction()
                    realm.deleteObjects(currentTask.records)
                    realm.commitWriteTransaction()
                }
                realm.beginWriteTransaction()
                realm.deleteObjects(currentCategory.tasks)
                realm.commitWriteTransaction()
            }
            realm.beginWriteTransaction()
            realm.deleteObjects(currentBudget.categories)
            realm.commitWriteTransaction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func displayResetCurrentRecordsAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all records for the current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as! Budget
            for var i:UInt = 0; i < currentBudget.categories.count; i++ {
                let currentCategory = currentBudget.categories.objectAtIndex(i) as! Category
                for var x:UInt = 0; x < currentCategory.tasks.count; x++ {
                    let currentTask = currentCategory.tasks.objectAtIndex(x) as! Task
                    realm.beginWriteTransaction()
                    realm.deleteObjects(currentTask.records)
                    currentTask.records.removeAllObjects()
                    currentTask.calcTime()
                    currentCategory.calcTime()
                    realm.commitWriteTransaction()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
}
