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
    private var nextIndex:Int!
    private var backgroundColors:[UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentIndex = 0
        dataSource = self
        delegate = self
        self.backgroundColors.append(UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1.0))
        self.backgroundColors.append(UIColor(red: 111/255, green: 177/255, blue: 222/255, alpha: 1.0))
        self.backgroundColors.append(UIColor(red: 113/255, green: 152/255, blue: 189/255, alpha: 1.0))
        self.backgroundColors.append(UIColor(red: 108/255, green: 130/255, blue: 156/255, alpha: 1.0))
        self.backgroundColors.append(UIColor(red: 97/255, green: 107/255, blue: 123/255, alpha: 1.0))
        self.backgroundColors.append(UIColor(red: 80/255, green: 83/255, blue: 90/255, alpha: 1.0))
        
        let storyboard = UIStoryboard(name: "iPhone", bundle: nil)
        
        orderedViewControllers.removeAll()
        
        for (var i=1; i<=6; i++) {
            orderedViewControllers.append(storyboard.instantiateViewControllerWithIdentifier("WelcomePage\(i)"))
        }
        
        
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
        
        self.view.backgroundColor = self.backgroundColors[currentIndex]
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

extension WelcomeViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let viewControllerIndex = orderedViewControllers.indexOf(pendingViewControllers.first!)
        self.nextIndex = viewControllerIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = nextIndex
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.view.backgroundColor = self.backgroundColors[self.currentIndex]
            }, completion: nil)
        }
    }
}