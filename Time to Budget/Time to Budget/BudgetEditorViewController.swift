//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit

class BudgetEditorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
