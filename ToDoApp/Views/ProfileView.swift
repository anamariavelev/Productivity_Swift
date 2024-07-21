import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    Text("Loading Profile...")
                    Button("Log out") {
                        viewModel.logout()
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                if let errorMessage = newValue {
                    alertMessage = errorMessage
                    showAlert = true
                }
            }
        }
    }

    @ViewBuilder
    func profile(user: User) -> some View {
        // Avatar
        Image("profil")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.green)
            .frame(width: 450, height: 450)
            .offset(y: -100)

        // User information
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                    .bold()
                Text(user.name)
            }
            HStack {
                Text("Email: ")
                    .bold()
                Text(user.email)
            }
            HStack {
                Text("Time here: ")
                    .bold()
                Text(viewModel.memberSinceText)
            }
        }
        .offset(y: -200)
        .padding()

        // Sign out button
        Button("Log out") {
            viewModel.logout()
        }
        .tint(.red)
        .padding()
        .bold()
        .offset(y: -200)

        Spacer()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
