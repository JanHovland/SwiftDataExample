//
//  SwiftDataExample.swift
//  SwiftDataExample
//
//  Created by Jan Hovland on 04/09/2024.
//

import SwiftUI
import SwiftData

struct SwiftDataExample: View {
    
    /// Intro to SwiftData - Model, Container, Fetch, Create, Update & Delete
    /// https://www.youtube.com/watch?v=mvXFGikltPc
    
    @Environment(\.modelContext) var content
    @State private var isShowingItemSheet = false
    @Query(sort: \Expense.date) var expenses: [Expense]
    @State private var expenseToEdit: Expense?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        content.delete(expenses[index])
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit) { expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No expenses", systemImage: "list.bullet.rectangle.portrait")
                    },  description: {
                        Text("Start adding expenses to see your list.")
                    },  actions: {
                        Button("Add Expense") {
                            isShowingItemSheet = true
                        }
                    })
                }
            }
        }
    }
}

struct ExpenseCell: View {
    
    let expense: Expense
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing:0) {
                Text("Date")
                HStack (alignment: .center) {
                    Text("\t\t\t")
                    Text(expense.date, format: .dateTime.month(.abbreviated).day())
                }
            }
            HStack(spacing:0) {
                Text("Name")
                HStack (alignment: .center) {
                    Text("\t\t\t")
                    Text(expense.name)
                }
            }
            HStack(spacing:0) {
                Text("Value")
                HStack (alignment: .center) {
                    Text("\t\t\t")
                    Text(expense.value, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                }
            }
            
        }
    }
}

struct AddExpenseSheet: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0.00
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateExpenseSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

