//
//  ToDoListItem.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import Foundation
//Check why struct in ToDoListItemViewViweModel
struct ToDoListItem: Codable, Identifiable, Hashable{
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    //var reminder: String?

    
    mutating func setDone(_ state: Bool){
        isDone = state
    }
}
