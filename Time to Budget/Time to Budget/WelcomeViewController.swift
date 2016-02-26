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
    private let Pg1Image = UIImageView(image: UIImage(named: "Pg1_Clock"))
    private let Pg1Text = UIImageView(image: UIImage(named: "Pg1_Text"))
    
    private let Pg2Image = UIImageView(image: UIImage(named: "Pg2_TrashCan"))
    private let Pg2Text = UIImageView(image: UIImage(named: "Pg2_Text"))
    
    private let Pg3Image = UIImageView(image: UIImage(named: "Pg3_MoneyBudget"))
    private let Pg3Text = UIImageView(image: UIImage(named: "Pg3_Text"))
    
    private let Pg4Image = UIImageView(image: UIImage(named: "Pg4_Watch"))
    private let Pg4Text = UIImageView(image: UIImage(named: "Pg4_Text"))
    
    private let Pg5Title = UIImageView(image: UIImage(named: "Pg5_Title"))
    private let Pg5Text = UIImageView(image: UIImage(named: "Pg5_Text"))
    
    private let Pg6Title = UIImageView(image: UIImage(named: "Pg6_Title"))
    private let Pg6Text = UIImageView(image: UIImage(named: "Pg6_Text"))
    
    override func viewDidLoad() {
        self.configureSubviews()
        self.configureAnimations()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func numberOfPages() -> Int {
        return 6
    }
    
    private func configureSubviews() {
        //self.contentView.addSubview(UIView())
    }
    
    private func configureAnimations() {
        //self.animator.addAnimation(BackgroundColorAnimation(view: self.scrollView))
    }
}