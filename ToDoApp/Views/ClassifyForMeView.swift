//
//  ScheduleForMeView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//


import SwiftUI

struct ClassifyForMeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedCategory: String?  // State to track the selected category
    
    @ObservedObject var viewModel: ClassifyForMeViewModel // Inject view model

    init(viewModel: ClassifyForMeViewModel) {
        self.viewModel = viewModel
    }
    var themeColor: Color {
        colorScheme == .light ? .green : .orange
    }
    
    let categories = [
        ("Food & Diet", "Explore healthy eating habits and nutritious recipes."),
        ("Health", "Take care of your physical and mental well-being."),
        ("Sports", "Stay active and enjoy various physical activities."),
        ("Work & Education", "Focus on career growth and lifelong learning."),
        ("Others", "Discover hobbies, social activities, and personal interests.")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HeaderV2(title: "Categories", subtitle: "What kind of tasks do you have?")
                    .offset(y: 130)
                
                ForEach(viewModel.categories, id: \.0) { category in
                    NavigationLink(destination: destinationView(for: category.0)) {
                        VCard(title: category.0, description: category.1, color: themeColor, textColor: .primary)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 120)
                    }
                }
                .offset(y: 100)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 100)
        }
        .padding(20)
        .onAppear {
            viewModel.fetchAndCategorizeTasksIfNeeded() // Fetch and categorize tasks if needed
        }
    }
    
    // Function to determine destination view based on category
    private func destinationView(for category: String) -> some View {
        switch category {
        case "Food & Diet":
            return AnyView(Food___Diet(viewModel: viewModel))
        case "Health":
            return AnyView(Health(viewModel: viewModel))
        case "Sports":
            return AnyView(Sports(viewModel: viewModel))
        case "Work & Education":
            return AnyView(Work(viewModel: viewModel))
        case "Others":
            return AnyView(Others(viewModel: viewModel))
        default:
            return AnyView(Others(viewModel: viewModel))
        }
    }
}

#Preview {
    ClassifyForMeView(viewModel: ClassifyForMeViewModel(userId: "f6S6M0HllnUufAiqMvvkrxri7X93"))
}
