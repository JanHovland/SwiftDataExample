//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by Jan Hovland on 04/09/2024.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct SwiftDataExampleApp: App {
    
 var body: some Scene {
        WindowGroup {
            SwiftDataExample()
        }
        .modelContainer(for: [Expense.self])
    }
}

