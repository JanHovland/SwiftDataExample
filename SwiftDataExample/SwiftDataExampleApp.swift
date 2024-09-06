//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by Jan Hovland on 04/09/2024.
//

import SwiftUI
import SwiftData
import CoreData

/// https://www.youtube.com/watch?v=PtQevkS1M2I

@main
struct SwiftDataExampleApp: App {
    
    var body: some Scene {
        WindowGroup {
            SwiftDataExample()
        }
        .modelContainer(for: [Expense.self])
    }
}




































