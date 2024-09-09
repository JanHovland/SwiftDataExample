//
//  SwiftDataExample.swift
//  SwiftDataExample
//
//  Created by Jan Hovland on 04/09/2024.
//

import SwiftUI
import SwiftData

struct SwiftDataExample: View {
    
    ///
    /// Data er knyttet til Ipad eller iPhone (ikke til begge legge inn share?)
    ///
    
    /// Intro to SwiftData - Model, Container, Fetch, Create, Update & Delete
    /// https://www.youtube.com/watch?v=mvXFGikltPc
    /// https://www.hackingwithswift.com/books/ios-swiftui/syncing-swiftdata-with-cloudkit
    /// https://www.kodeco.com/books/macos-by-tutorials/v1.0/chapters/3-adding-menus-toolbars
    /// https://www.youtube.com/watch?v=PtQevkS1M2I
    
    @Environment(\.modelContext) var content
    @State private var isShowingItemSheet = false
    @Query(sort: \Expense.date) var expenses: [Expense]
    @State private var expenseToEdit: Expense?
    @State private var search = ""
    
    var filterExpenses: [Expense] {
        guard !search.isEmpty else {return expenses}
        return expenses.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filterExpenses) { expense in
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
#if os(iOS)
            .searchable(text: $search, placement: .navigationBarDrawer , prompt: "Search")
            .navigationBarTitleDisplayMode(.large)
#else
            .searchable(text: $search, placement: .automatic , prompt: "Search")
#endif
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
                    Text(expense.date, format: .dateTime.day().month().year())
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
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
            }
            .navigationTitle("New Expense")
#if os(iOS)
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
#else
            .toolbar {
                ToolbarItemGroup(placement: .destructiveAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense)
                        dismiss()
                    }
                }
            }
            
#endif
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
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
            }
            .navigationTitle("Update Expense")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
#else
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .destructiveAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
#endif
        }
    }
}

