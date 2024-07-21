//
//  CoreDataProvider.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 15.03.2024.
// pt Mac - not used

import Foundation
import CoreData

class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "RemindersModel")
        persistentContainer.loadPersistentStores{
            description, error in
            if let error{
                fatalError("Error initializing RemindersModel \(error)")
            }
        }
    }
    
}
