//
//  MainView.swift
//  WatchOSToDoApp Watch App
//
//  Created by Ana Maria Velev on 27.06.2024.
//

import SwiftUI

struct MainView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            VStack {
                // A welcoming animation
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    )
                    .onAppear {
                        self.isAnimating = true
                    }
                
                Text("Welcome to ToDoApp!")
                    .font(.headline)
                    .padding(.top, 10)
                
                Spacer()
                
                // Navigation Buttons
                NavigationLink(destination: ContentView()) {
                    Text("See Task List")
                        .font(.headline)
                        .padding()
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: AddTaskView()) {
                    Text("Add Task")
                        .font(.headline)
                        .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}
