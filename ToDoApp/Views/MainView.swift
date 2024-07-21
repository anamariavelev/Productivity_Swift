//
//  ContentView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            //signed in
            accountView
            
        } else {
                LoginView()
            
        }
        
    }
    
    @ViewBuilder
    var accountView: some View{
        TabView {
            DashboardView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                        .foregroundColor(.primary)
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                        .foregroundColor(.primary)
                }
        }
        .background(Color.white)
    }
}

#Preview {
    MainView()
}
