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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    }

    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
