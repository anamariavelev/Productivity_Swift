//
//  EditItemViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

class EditItemViewModel: ObservableObject {
    @Published var title: String
    @Published var dueDate: Date
    @Published var selectedReminderIndex: Int // Newly added
    
    init(item: ToDoListItem, selectedReminderIndex: Int = 6) { // Default value for selectedReminderIndex is 6 (None)
        self.title = item.title
        self.dueDate = Date(timeIntervalSince1970: item.dueDate)
        self.selectedReminderIndex = selectedReminderIndex // Initialize selectedReminderIndex
    }
    
    func saveChanges(for item: ToDoListItem, reminderOptions: [String]) {
        // Create a new instance of ToDoListItem with updated values
        var updatedItem = ToDoListItem(id: item.id,
                                       title: title,
                                       dueDate: dueDate.timeIntervalSince1970,
                                       createdDate: item.createdDate,
                                       isDone: item.isDone)
        
        // Update the task in Firestore
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(uid).collection("options").document(uid).collection("todos").document(item.id).setData(updatedItem.asDictionary()) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        // Schedule local notification if a reminder option is selected
        if selectedReminderIndex < reminderOptions.count - 1 {
            scheduleLocalNotification(reminderOptions: reminderOptions)
        }
    }
    
    func scheduleLocalNotification(reminderOptions: [String]) {
        // Get the selected reminder interval based on the selected index
        let reminderInterval: TimeInterval
        switch selectedReminderIndex {
        case 0: // 1 week
            reminderInterval = -7 * 24 * 60 * 60
        case 1: // 1 day
            reminderInterval = -1 * 24 * 60 * 60
        case 2: // 2 hours
            reminderInterval = -2 * 60 * 60
        case 3: // 1 hour
            reminderInterval = -1 * 60 * 60
        case 4: // 30 minutes
            reminderInterval = -30 * 60
        case 5: // 10 minutes
            reminderInterval = -10 * 60
        default:
            return // None
        }
        
        // Calculate the due date with the reminder interval
        let dueDateWithReminder = dueDate.addingTimeInterval(reminderInterval)
        
        // Schedule local notification
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Your task '\(title)' is due soon!"
        content.sound = UNNotificationSound.default
        
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDateWithReminder)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let requestId = UUID().uuidString
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        center.add(request)
    }
}
