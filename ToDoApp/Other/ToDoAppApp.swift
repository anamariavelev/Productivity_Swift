//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI
import FirebaseCore
import UserNotifications

@main
struct ToDoAppApp: App {
// APLICATIE BUNA
    
    init(){
        FirebaseApp.configure()
        requestNotificationAuthorization()

    }
    
    var body: some Scene {
          WindowGroup {
              
              MainView()
              
          }
      }
      
      private func requestNotificationAuthorization() {
          let center = UNUserNotificationCenter.current()
          center.requestAuthorization(options: [.alert, .sound]) { granted, error in
              if let error = error {
                  print("Error requesting notification authorization: \(error.localizedDescription)")
              }
          }
      }
    
    
  }



