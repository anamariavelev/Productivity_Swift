//
//  LoginViewViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    init(){}
    
    func login(){
  
        guard validate() else{
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                   guard let self = self else { return }
                   
                   if let error = error {
                       errorMessage = "Invalid credentials!"
                   } else {
                       self.errorMessage = ""
                   }
               }
        
    }
    
    
    func validate() -> Bool{
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty  else{
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".")else{
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        //error message for wrong password/email
        
        return true
        //print("we re ok we got here")
    }
    
}
