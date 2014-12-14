//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

class BudgetItemEditorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentBudgetItem:BudgetItem!
    var timeTotalRemainingHrs:NSNumber = 168
    var timeTotalRemainingMins:NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backItem?.title = "Done"
        if timeTotalRemainingMins == 0 && timeTotalRemainingHrs != 0 {
            self.navigationItem.title = "\(timeTotalRemainingHrs):00"
        }
        else if timeTotalRemainingMins != 0 && timeTotalRemainingHrs == 0 {
            self.navigationItem.title = "00:\(timeTotalRemainingMins)"
        }
        else if timeTotalRemainingMins == 0 && timeTotalRemainingHrs == 0 {
            self.navigationItem.title = "00:00"
        }
        else if timeTotalRemainingMins != 0 && timeTotalRemainingHrs != 0 {
            self.navigationItem.title = "\(timeTotalRemainingHrs):\(timeTotalRemainingMins)"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        /*
        currentBudgetItem.category = categoryTextField.text
        currentBudgetItem.name = nameTextField.text
        currentBudgetItem.descript = descriptionTextField.text
        currentBudgetItem.timeHrsRemain = hoursTextField.text
        currentBudgetItem.timeMinsRemain = minsTextField.text
        
        appDelegate.saveContext()
    */
    }
    
    
}
