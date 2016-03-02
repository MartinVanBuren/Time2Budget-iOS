//
//  WelcomeViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/29/16.
//  Copyright © 2016 Arrken Software, LLC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIPageViewController {
    
    private var orderedViewControllers:[UIViewController] = []
    private var currentIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        let storyboard = UIStoryboard(name: "iPhone", bundle: nil)
        
        orderedViewControllers.removeAll()
        
        for (var i=1; i<=6; i++) {
            orderedViewControllers.append(storyboard.instantiateViewControllerWithIdentifier("WelcomePage\(i)"))
        }
        
        currentIndex = 0
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view.isKindOfClass(UIScrollView) {
                view.frame = UIScreen.mainScreen().bounds
            } else if view.isKindOfClass(UIPageControl) {
                view.backgroundColor = UIColor.clearColor()
            }
        }
        
        stylePageControl()
    }
    
    private func stylePageControl(color: UIColor = UIColor.clearColor()) {
        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
        
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension WelcomeViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = currentIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
}