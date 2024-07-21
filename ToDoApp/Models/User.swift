//
//  User.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import Foundation
import SwiftUI

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    let theme: String

        
        func asDictionary() -> [String: Any] {
            return [
                "id": id,
                "name": name,
                "email": email,
                "joined": joined,
                "theme": theme
            ]
        }
    }
