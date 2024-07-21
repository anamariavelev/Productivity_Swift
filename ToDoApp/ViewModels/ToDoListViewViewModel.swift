//
//  ToDoListViewViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//


import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import WatchConnectivity

class ToDoListViewViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var showingNewItemView = false
    @Published var items: [ToDoListItem] = []
    private let userId: String
    private var db = Firestore.firestore()
    var session: WCSession

    init(userId: String, session: WCSession = .default) {
        self.userId = userId
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        fetchItems()
    }
    
    func deleteItem(title: String) {
        guard let item = items.first(where: { $0.title == title }) else {
            print("Item not found")
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("options")
            .document(userId)
            .collection("todos")
            .document(item.id)
            .delete { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                } else {
                    self.fetchItems() // Refresh list after deletion
                }
            }
    }
    
    func fetchItems() {
        db.collection("users/\(userId)/options/\(userId)/todos").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching items: \(error)")
                return
            }
            
            self.items = querySnapshot?.documents.compactMap { document in
                try? document.data(as: ToDoListItem.self)
            } ?? []
            
            self.sendMessage()
        }
    }
    
    func sendMessage() {
        print("Sending message to watch...")
        guard session.isReachable else {
            print("WCSession is not reachable")
            return
        }
        
        let titles = items.map { $0.title }
        let message = ["titles": titles]
        
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let title = message["deleteTitle"] as? String {
            deleteItem(title: title)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        // Handle receiving data from watch if needed
    }
}

