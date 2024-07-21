//
//  Extensions.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import Foundation

extension Encodable{
    func asDictionary() -> [String: Any]{
        guard let data = try? JSONEncoder().encode(self) else{ //data din current thing; if we fail return empty dict
            return [:]
        }
        
        do {
            //convert data to dictionary
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
