//
//  ForgotPassView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 26.02.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ForgotPassView: View {
    
    @StateObject var viewModelPass = ForgotPassViewModel()
    
    
    
    var body: some View {
        NavigationStack{
            VStack{
                HeaderView(title: "To Do App", subtitle: "Password Recovery", angle: -0, background: .orange)//header
                    .offset(y: 60)
                //login form
                
                Form{
                    if !viewModelPass.errorMessage.isEmpty{
                        Text(viewModelPass.errorMessage)
                            .foregroundColor(.red)
                    } else if !viewModelPass.successMessage.isEmpty {
                        Text(viewModelPass.successMessage)
                            .foregroundColor(.green)
                    }
                    
                    
                    TextField("Email address", text: $viewModelPass.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)

                    TLButtonView(
                        title: "Reset password",
                        background: .orange
                    ){
                        viewModelPass.sendPasswordResetEmail()
                       
                    }
                    
                
                }
                
                

                //creTE account
                VStack{
                    Text("Don't have an account?")
                        //registration stuff
                    NavigationLink("Create an account", destination: RegisterView())
                        .foregroundColor(.orange)
                    
                }
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    ForgotPassView()
}
