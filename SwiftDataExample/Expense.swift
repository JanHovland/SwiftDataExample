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
    
//
//  NSLocalizedFailureReason = "CloudKit integration does not support unique constraints.
//  The following entities are constrained:\nExpense: name";
//
//  @Attribute(.unique) var name: String = ""
//  #Unique<Expense>([\.name, \.date, \.value])
//  #Unique<Expense>([\.name])
//    
    var name: String = ""
    var date: Date = Date.now
    var value: Double = 0.00
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
