//
//  EditItemView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//

import SwiftUI

struct EditItemView: View {
    let item: ToDoListItem
    @Binding var isPresented: Bool
    @Binding var showingEditItemView: Bool
    @StateObject var viewModel: EditItemViewModel
    var onDismiss: () -> Void
    
    let reminderOptions = ["1 week", "1 day", "2 hours", "1 hour", "30 minutes", "10 minutes", "None"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { // Remove unnecessary space between elements
                TextField("Title", text: $viewModel.title)
                    .font(.system(size: 32))
                    .bold()
                    .padding()
                
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                // Reminder
                Text("Set a reminder:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .offset(y: -60)
                
                Picker("Reminder", selection: $viewModel.selectedReminderIndex) {
                    ForEach(0..<reminderOptions.count) { index in
                        Text(reminderOptions[index])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 90)
                .padding()
                .offset(y: -60)
                
                
                
                TLButtonView(title: "Save", background: .pink) {
                    viewModel.saveChanges(for: item, reminderOptions: reminderOptions)
                    isPresented = false
                    showingEditItemView = false
                    onDismiss()
                }
                .padding()
                .offset(y: -70)
                .frame(width: 350, height: 85)

            }
            .navigationBarItems(trailing: Button("Back") {
                isPresented = false
            })
            .padding() // Add padding to the VStack
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}




#Preview {
    NavigationStack {
        EditItemView(
            item: ToDoListItem(
                id: "1",
                title: "Example",
                dueDate: Date().timeIntervalSince1970,
                createdDate: Date().timeIntervalSince1970,
                isDone: false
            ),
            isPresented: .constant(true),
            showingEditItemView: .constant(true),
            viewModel: EditItemViewModel(item: ToDoListItem(
                id: "1",
                title: "Example",
                dueDate: Date().timeIntervalSince1970,
                createdDate: Date().timeIntervalSince1970,
                isDone: false
            )),
            onDismiss: {}
        )
    }
}



