//
//  DashboardViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class DashboardViewModel: ObservableObject{
    
    private let userId: String
    //public let color: Color = .blue
    
    init(userId: String){
        self.userId = userId
         
    }
    
    
}
