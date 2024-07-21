//
//  WatchAddTaskViewModel.swift
//  WatchOSToDoApp WatchKit Extension
//
//  Created by Ana Maria Velev on 27.06.2024.
//

import Foundation
import WatchConnectivity

class WatchAddTaskViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var title: String = ""
    @Published var dueDate = Date()
    @Published var selectedReminderIndex = 0
    @Published var showAlert = false // Add showAlert property
    
    private var wcSession: WCSession
    
    override init() {
        self.wcSession = WCSession.default
        super.init()
        self.wcSession.delegate = self
        self.wcSession.activate()
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && dueDate >= Date()
    }
    
    func saveTask(reminderOptions: [String]) {
        guard canSave else {
            showAlert = true // Show alert when saving is not possible
            return
        }
        
        let task = ["title": title, "dueDate": dueDate.timeIntervalSince1970, "reminderOption": reminderOptions[selectedReminderIndex]] as [String : Any]
        
        if wcSession.isReachable {
            wcSession.sendMessage(task, replyHandler: nil) { error in
                print("Error sending message to iPhone: \(error.localizedDescription)")
                self.showAlert = true // Show alert on send message error
            }
        } else {
            print("Watch is not reachable")
            self.showAlert = true // Show alert when watch is not reachable
        }
    }
    
    // MARK: - WCSessionDelegate methods
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activation completed with state: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message from iPhone: \(message)")
    }
}

