import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewViewModel: ObservableObject {
    init() {}

    @Published var user: User? = nil
    @Published var memberSinceText: String = ""
    @Published var errorMessage: String? = nil

    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user ID found."
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                self?.errorMessage = "Error fetching user data: \(error.localizedDescription)"
                return
            }
            
            guard let data = snapshot?.data() else {
                self?.errorMessage = "No data found for user."
                return
            }

            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    theme: data["theme"] as? String ?? "" // Corrected line
                )
                
                if let user = self?.user {
                    self?.calculateMemberSinceText(user: user)
                }
            }
        }
    }
    
    private func calculateMemberSinceText(user: User) {
        let joinedDate = Date(timeIntervalSince1970: user.joined)
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: joinedDate, to: currentDate)

        if let years = components.year, let months = components.month, let days = components.day {
            let yearsString = years > 0 ? "\(years) year" + (years > 1 ? "s" : "") : ""
            let monthsString = months > 0 ? "\(months) month" + (months > 1 ? "s" : "") : ""
            let daysString = days > 0 ? "\(days) day" + (days > 1 ? "s" : "") : ""

            var timeString = ""
            if !yearsString.isEmpty {
                timeString += yearsString
            }
            if !monthsString.isEmpty {
                if !timeString.isEmpty {
                    timeString += ", "
                }
                timeString += monthsString
            }
            if !daysString.isEmpty {
                if !timeString.isEmpty {
                    timeString += ", "
                }
                timeString += daysString
            }

            self.memberSinceText = "You're with us for \(timeString) now"
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Failed to log out: \(error.localizedDescription)"
        }
    }
}
