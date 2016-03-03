//
//  WelcomeButtonsController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/16.
//  Copyright © 2016 Arrken Software, LLC. All rights reserved.
//

import Foundation
import UIKit

class WelcomeButtonsController: UIViewController {
    @IBOutlet weak var notifsButton: UIButton!
    @IBOutlet weak var skipTutorialButton: UIButton!
    @IBOutlet weak var runTutorialButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if notifsButton != nil {
            Style.button(notifsButton)
        }
        
        if skipTutorialButton != nil {
            Style.button(skipTutorialButton)
        }
        
        if runTutorialButton != nil {
            Style.button(runTutorialButton)
        }
    }
    
    @IBAction func notifsButtonPressed(sender: UIButton) {
        // Check if the user wants to enable or disable notifications
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
    }
    
    @IBAction func skipTutorialButtonPressed(sender: UIButton) {
        // Disable welcome screen for future app starts.
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(false, forKey: "showWelcome")
        
        Tutorial.disableTutorials()
        
        // Load and display the main app.
        let storyboard = UIStoryboard(name: "iPhone", bundle: nil)
        let mainView = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController")
        self.presentViewController(mainView, animated: true, completion: nil)
    }
    
    @IBAction func runTutorialButtonPressed(sender: UIButton) {
        // Disable welcome screen for future app starts.
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setBool(false, forKey: "showWelcome")
        
        Tutorial.enableTutorials()
        
        // Load and display the main app.
        let storyboard = UIStoryboard(name: "iPhone", bundle: nil)
        let mainView = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController")
        self.presentViewController(mainView, animated: true, completion: nil)
    }
}