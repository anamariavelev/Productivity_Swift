//
//  NewDashItemViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//

import Foundation
import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewDashItemViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init(){}
    
    func toggleIsDone(item: DashboardItem){
        var itemCopy = item
        
        //get current user id
        guard let uId =  Auth.auth().currentUser?.uid else{
            return
        }
            
            //ctreate model
            let newId = UUID().uuidString
            let newItem = DashboardItem(id: newId, title: title)
            
            // Save to database -> sub-collection of current user
            let db = Firestore.firestore()
            
            db.collection("users")
                .document(uId)
                .collection("options")
                .document(newId)
                .setData(newItem.asDictionary())
            
        
    }
}
