//
//  WelcomeViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/12/16.
//  Copyright © 2016 Arrken Software, LLC. All rights reserved.
//

import UIKit
import RazzleDazzle

class WelcomeViewController: AnimatedPagingScrollViewController {
    
    override func viewDidLoad() {
        self.configureSubviews()
        self.configureAnimations()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func numberOfPages() -> Int {
        return 4
    }
    
    private func configureSubviews() {
        //self.contentView.addSubview(UIView())
    }
    
    private func configureAnimations() {
        //self.animator.addAnimation(BackgroundColorAnimation(view: self.scrollView))
    }
}