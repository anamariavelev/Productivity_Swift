
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ForgotPassViewModel: ObservableObject {
    @Published var email = ""
    @Published var errorMessage = ""
    @Published var successMessage = ""
    
    init() {}
    
    
    
    func sendPasswordResetEmail() {
            let db = Firestore.firestore()
            let usersRef = db.collection("users")
            
            
            usersRef.whereField("email", isEqualTo: email).getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    
                    // Check if any documents are returned
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        
                        // Email exists in Firestore
                        Auth.auth().sendPasswordReset(withEmail: self.email) { [weak self] error in
                            guard let self = self else { return }
                            
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                                self.successMessage = ""
                            } else {
                                self.successMessage = "An email has been sent to the email address \(self.email)"
                                self.errorMessage = ""
                            }
                        }
                    } else {
                        //email doesn't exist in Firestore
                        self.errorMessage = "No account exists with the provided email. Please create an account."
                        self.successMessage = ""
                    }
                }
            }
        }
    
    
        
        func validate() -> Bool {
            errorMessage = ""
            
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                errorMessage = "Please fill in all fields"
                return false
            }
            
            guard email.contains("@") && email.contains(".")else {
                errorMessage = "Please enter a valid email address."
                return false
            }
            
            return true
        }
    }

