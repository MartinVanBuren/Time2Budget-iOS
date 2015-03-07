//
//  CloudKitManager.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/7/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    class var sharedInstance: CloudKitManager {
        struct Static {
            static let instance: CloudKitManager = CloudKitManager()
        }
        return Static.instance
    }
    
    var container:CKContainer
    var publicDB:CKDatabase
    var PrivateDB:CKDatabase
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        PrivateDB = container.privateCloudDatabase
    }
    
    
}