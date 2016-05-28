//
//  Protocol.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 10/1/15.
//  Copyright © 2015 Arrken Games, LLC. All rights reserved.
//

protocol writeTaskBackDelegate {
    func writeTaskBack(task: Task)
}

protocol writeCategoryBackDelegate {
    func writeCategoryBack(cat: Category)
}
