//
//  Expense.swift
//  SwiftDataExample
//
//  Created by Jan Hovland on 04/09/2024.
//

import Foundation
import SwiftData

@Model
class Expense {
//    @Attribute(.unique) var name: String
    var name: String = ""
    var date: Date = Date.now
    var value: Double = 0.00
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
