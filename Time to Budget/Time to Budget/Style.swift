//
//  Style.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 9/15/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit

public class Style {
    class func navbarSetColor(#nav: UINavigationBar) {
        nav.barStyle = UIBarStyle.Black
        nav.tintColor = UIColor.whiteColor()
        nav.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav.barTintColor = UIColor(red: 122/255, green: 158/255, blue: 224/255, alpha: 255/255)
    }
    
    
}