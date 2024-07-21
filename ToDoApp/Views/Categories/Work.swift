//
//  Work.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 25.04.2024.
//

import SwiftUI

struct Work: View {
    @ObservedObject var viewModel: ClassifyForMeViewModel
    
    var body: some View {
        VStack {
            HeaderV2(title: "Work & Education", subtitle: "Focus on career growth and lifelong learning.")
                .offset(y: 110)
                .padding()
                Spacer()
            
            if let tasks = viewModel.categorizedTasks["Work & Education"] {
                            List(tasks, id: \.id) { task in
                                HStack {
                                    Text(task.title)
                                        .padding()
                                    Spacer()
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("You don't have any work or education-related tasks.")
                                .padding()
                        }
                        
                        Spacer()
                .padding()
        }
    }
}
