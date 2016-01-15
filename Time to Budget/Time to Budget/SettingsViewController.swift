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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
        
        self.navigationItem.title = "Settings"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
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
        case 0:
            return Factory.prepareBasicHeader(tableView: self.tableView, titleText: "Testing Tools")
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
            case 4:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Archive Budget")
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Feedback")
            case 1:
                return Factory.prepareSettingsAboutCell(tableView: self.tableView)
            case 2:
                return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Privacy Policy")
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
            //let realm = Database.getRealm()
            for views in tabBarController!.viewControllers! {
                (views as! UINavigationController).popToRootViewControllerAnimated(false)
            }
            
            switch indexPath.row {
            case 0:
                displayResetAllAlert()
            case 1:
                displayResetHistoryAlert()
            case 2:
                displayResetCurrentBudgetAlert()
            case 3:
                displayResetCurrentRecordsAlert()
            case 4:
                displayArchiveBudgetAlert()
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                let url = NSURL(string: "https://drive.google.com/open?id=12NlkoJnnjjaXK5Ruc9JV-xGqpk3uHLlHHTOvoiqmQ2U")
                UIApplication.sharedApplication().openURL(url!)
            case 1:
                let url = NSURL(string: "http://robertkennedy.me/blog/")
                UIApplication.sharedApplication().openURL(url!)
            case 2:
                let url = NSURL(string: "https://googledrive.com/host/0ByiIRCNWZES_V2x3eWd6QXYtTjA")
                UIApplication.sharedApplication().openURL(url!)
            default:
                return
            }
        default:
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func displayResetAllAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all information?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            try! realm.write {
                realm.deleteAll()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
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
    
    func displayResetCurrentBudgetAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase the entire current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let currentBudget = realm.objects(Budget).filter("isCurrent == TRUE").first!
            for var i = 0; i < currentBudget.categories.count; i++ {
                let currentCategory = currentBudget.categories[i]
                for var x = 0; x < currentCategory.tasks.count; x++ {
                    let currentTask = currentCategory.tasks[x]
                    try! realm.write {
                        realm.delete(currentTask.records)
                    }
                }
                try! realm.write {
                    realm.delete(currentCategory.tasks)
                }
            }
            try! realm.write {
                realm.delete(currentBudget.categories)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func displayResetCurrentRecordsAlert() {
        let realm = Database.getRealm()
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to erase all records for the current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let currentBudget = realm.objects(Budget).filter("isCurrent == TRUE").first!
            for var i = 0; i < currentBudget.categories.count; i++ {
                let currentCategory = currentBudget.categories[i]
                for var x = 0; x < currentCategory.tasks.count; x++ {
                    let currentTask = currentCategory.tasks[x]
                    try! realm.write {
                        realm.delete(currentTask.records)
                        currentTask.records.removeAll()
                        currentTask.calcTime()
                        currentCategory.calcTime()
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func displayArchiveBudgetAlert() {
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to archive the current budget?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            Database.newBudget()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
}
