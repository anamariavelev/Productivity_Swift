import Foundation
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import WatchConnectivity

class NewItemViewViewModel: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var title: String = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    @Published var selectedReminderIndex = 0
    
    // Watch Connectivity
    var wcSession: WCSession
    
    override init() {
        self.wcSession = WCSession.default
        super.init()
        
        // Request notification authorization when the ViewModel is initialized
        requestNotificationAuthorization()
        
        // Activate WCSession
        if WCSession.isSupported() {
            self.wcSession.delegate = self
            self.wcSession.activate()
        }
    }
    
    func saved(reminderOptions: [String]) {
        guard canSave else { return }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create a model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId, title: title, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false)
        
        // Save to database -> sub-collection of current user
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("options")
            .document(uId)
            .collection("todos") // Access todos collection under options
            .document(newId) // Use newId for document ID
            .setData(newItem.asDictionary())
        
        // Schedule local notification
        scheduleLocalNotification(reminderOptions: reminderOptions)
    }
    
    func sendTitleToWatch(_ title: String) {
        guard wcSession.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let message = ["title": title]
        wcSession.sendMessage(message, replyHandler: nil) { error in
            print("Error sending title to watch: \(error.localizedDescription)")
        }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date() else {
            return false
        }
        return true
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleLocalNotification(reminderOptions: [String]) {
        guard selectedReminderIndex < reminderOptions.count - 1 else {
            // If it's 'None', do nothing
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Your task '\(title)' is due soon!"
        content.sound = UNNotificationSound.default
        
        // Calculate the time interval for the reminder based on the selected option
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
            fatalError("Invalid reminder index")
        }
        
        let dueDateWithReminder = dueDate.addingTimeInterval(reminderInterval)
        
        // trigger
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDateWithReminder)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        // request
        let requestId = UUID().uuidString
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    // MARK: - WCSessionDelegate methods
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activation completed with state: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let title = message["title"] as? String else {
            return
        }
        
        print("Received title from watch: \(title)")
        
        // Handle the received title
        self.title = title
        
        // Save the task using received title
        saved(reminderOptions: []) // Pass appropriate reminderOptions
        
        // Optionally, acknowledge receipt to the watch
        let replyMessage = ["acknowledged": true]
        session.sendMessage(replyMessage, replyHandler: nil, errorHandler: { error in
            print("Error sending acknowledgment to watch: \(error.localizedDescription)")
        })
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
        session.activate()
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange: \(session)")
    }
}
