//
//  NewItemView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.05.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    // Reference to WatchConnector
    //@StateObject var watchConnector = WatchConnector()
    
    let reminderOptions = ["1 week", "1 day", "2 hours", "1 hour", "30 minutes", "10 minutes", "None"]
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding()
            Form {
                // Title
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Due Date
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                // Reminder
                Text("Set a reminder:")
                    .multilineTextAlignment(.center)
                    .offset(x: 98)
                    .bold()
                Picker("Reminder", selection: $viewModel.selectedReminderIndex) {
                    ForEach(0..<reminderOptions.count) { index in
                        Text(reminderOptions[index])
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                // Button
                TLButtonView(title: "Save", background: .pink) {
                    if viewModel.canSave {
                        viewModel.saved(reminderOptions: reminderOptions)
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .frame(height: 50)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a valid title and due date in the future."), dismissButton: .default(Text("OK")))
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: .constant(true))
    }
}
