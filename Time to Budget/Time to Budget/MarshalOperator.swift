//
//  MarshalOperator.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/24/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation

infix operator ~> {}

private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

func ~> <R> (backgroundClosure: () -> R, mainClosure: (result: R) -> ()) {
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), {
            mainClosure(result: result)
        })
    }
}