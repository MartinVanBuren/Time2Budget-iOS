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
        /*
        switch indexPath.row {
        case 0:
            return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Clear Database")
        case 1:
            return Factory.prepareBasicCell(tableView: self.tableView, titleText: "Feedback")
        case 2:
            return Factory.prepareSettingsAboutCell(tableView: self.tableView)
        default:
            return UITableViewCell()
        }
        */
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        switch indexPath.row {
        case 0:
            for views in tabBarController!.viewControllers! {
                (views as UINavigationController).popToRootViewControllerAnimated(false)
            }
            let realm = Database.getRealm()
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            realm.commitWriteTransaction()
        case 1:
            let url = NSURL(string: "https://bitbucket.org/arrkensoftware/timetobudget_ios/issues")
            UIApplication.sharedApplication().openURL(url!)
        case 2:
            let url = NSURL(string: "https://arrken.com")
            UIApplication.sharedApplication().openURL(url!)
        default:
            break
        }
        */
        
        switch indexPath.section {
        case 0:
            let realm = Database.getRealm()
            for views in tabBarController!.viewControllers! {
                (views as UINavigationController).popToRootViewControllerAnimated(false)
            }
            
            switch indexPath.row {
            case 0:
                realm.beginWriteTransaction()
                realm.deleteAllObjects()
                realm.commitWriteTransaction()
            case 1:
                realm.beginWriteTransaction()
                realm.deleteObjects(Budget.objectsWhere("isCurrent = FALSE"))
                realm.commitWriteTransaction()
            case 2:
                let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
                realm.beginWriteTransaction()
                realm.deleteObjects(currentBudget.categories)
                realm.commitWriteTransaction()
            case 3:
                let currentBudget = Budget.objectsWhere("isCurrent = TRUE").firstObject() as Budget
                for var i:UInt = 0; i < currentBudget.categories.count; i++ {
                    let currentCategory = currentBudget.categories.objectAtIndex(i) as Category
                    for var x:UInt = 0; x < currentCategory.tasks.count; x++ {
                        let currentTask = currentCategory.tasks.objectAtIndex(x) as Task
                        realm.beginWriteTransaction()
                        realm.deleteObjects(currentTask.records)
                        realm.commitWriteTransaction()
                    }
                }
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
}
