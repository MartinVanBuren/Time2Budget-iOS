//
//  WelcomeViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/12/16.
//  Copyright © 2016 Arrken Software, LLC. All rights reserved.
//

import UIKit

class WelcomeViewController: KDIntroViewController {
    
    
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        setup(["view1", "view2", "view3", "view4"])
    }
    
    override func moveEverythingAccordingToIndex(index: CGFloat) {
        
    }
}