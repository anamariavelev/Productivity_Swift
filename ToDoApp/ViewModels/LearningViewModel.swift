//
//  LearningViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 15.04.2024.
//
import Foundation
import OpenAISwift
import SwiftUI

final class LearningViewModel: ObservableObject{
    init(){}
    
    private var client: OpenAISwift?
    
    func setup() { 
        let apiConfig = OpenAISwift.Config.makeDefaultOpenAI()
        client = OpenAISwift(config: apiConfig) }


    
    func send(text:String, completion: @escaping (String)-> Void){
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: {result in
            switch result{
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
    
}

