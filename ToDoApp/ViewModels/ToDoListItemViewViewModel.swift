//
//  ToDoListItemViewViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

///view model for a single to do list item - each row in items list

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ToDoListItemViewViewModel: ObservableObject{
    
    init(){}
    
    func toggleIsDone(item: ToDoListItem) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid =  Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Use the correct path to access the todo item
        db.collection("users")
            .document(uid)
            .collection("options")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id) // Access the todo item using its ID
            .setData(itemCopy.asDictionary())
    }

}

