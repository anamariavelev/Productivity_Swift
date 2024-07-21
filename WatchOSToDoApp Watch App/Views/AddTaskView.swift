//
//  AddTaskView.swift
//  WatchOSToDoApp Watch App
//
//  Created by Ana Maria Velev on 27.06.2024.
//

import SwiftUI

struct AddTaskView: View {
    @StateObject var viewModel = WatchAddTaskViewModel()
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var selectedReminderIndex = 0
    
    let reminderOptions = ["1 week", "1 day", "2 hours", "1 hour", "30 minutes", "10 minutes", "None"]
    
    var body: some View {
        VStack {
            Text("Add Task")
                .font(.headline)
                .padding(.top, 10)
            
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter task title", text: $viewModel.title)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("Due Time")) {
                    DatePicker("Due Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Reminder")) {
                    Picker("Reminder", selection: $selectedReminderIndex) {
                        ForEach(0..<reminderOptions.count, id: \.self) { index in
                            Text(reminderOptions[index])
                        }
                    }
                }
                
                Button(action: {
                    viewModel.dueDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: selectedTime),
                                                              minute: Calendar.current.component(.minute, from: selectedTime),
                                                              second: 0,
                                                              of: selectedDate) ?? Date()
                    viewModel.selectedReminderIndex = selectedReminderIndex
                    viewModel.saveTask(reminderOptions: reminderOptions)
                }) {
                    Text("Save Task")
                        .font(.headline)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a valid title and due date in the future."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
