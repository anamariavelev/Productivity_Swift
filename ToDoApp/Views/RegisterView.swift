//
//  RegisterView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var theme: Color = .blue

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(title: "To Do App", subtitle: "Create your account", angle: 15, background: .green)
                    .offset(y: 60)

                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }

                    TextField("Full Name", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())

                    TLButtonView(
                        title: "Create Account",
                        background: .green
                    ) {
                        viewModel.register()
                    }
                }

                Spacer()
            }
            .alert(isPresented: $viewModel.showVerificationAlert) {
                Alert(
                    title: Text("Email Verification"),
                    message: Text("Please check your email to verify your account before logging in."),
                    dismissButton: .default(Text("OK")) {
                        // Optionally navigate to the login screen after verification
                    }
                )
            }
        }
    }
}

#if DEBUG
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
#endif



