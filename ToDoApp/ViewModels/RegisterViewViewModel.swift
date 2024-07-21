//
//  RegisterViewViewModel.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var errorMessage = ""
    @Published var showVerificationAlert = false
    @Published var theme: String = "#000000" // Default color

    init() {}

    func register() {
        guard validate() else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let authUser = result?.user {
                // Send verification email
                authUser.sendEmailVerification { error in
                    if let error = error {
                        self.errorMessage = "Failed to send verification email: \(error.localizedDescription)"
                    } else {
                        // Save user data to Firestore after email verification
                        let newUser = User(id: authUser.uid, name: self.name, email: self.email, joined: Date().timeIntervalSince1970, theme: self.theme)
                        self.saveUserToFirestore(newUser)
                    }
                }
            }
        }
    }

    private func saveUserToFirestore(_ user: User) {
        let db = Firestore.firestore()
        db.collection("users").document(user.id).setData(user.asDictionary()) { error in
            if let error = error {
                self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
            } else {
                // User data saved successfully, show verification alert
                self.showVerificationAlert = true
                // Sign the user out to prevent immediate login
                try? Auth.auth().signOut()
            }
        }
    }

    func validate() -> Bool {
        errorMessage = ""

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        guard password.count >= 8 else {
            errorMessage = "Please enter a password with 8 or more characters."
            return false
        }

        return true
    }
}

