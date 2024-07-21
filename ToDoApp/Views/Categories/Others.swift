//
//  Others.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 25.04.2024.
//

import SwiftUI

struct Others: View {
    @ObservedObject var viewModel: ClassifyForMeViewModel
    
    var body: some View {
        VStack {
            HeaderV2(title: "Others", subtitle: "Discover hobbies, social activities, and personal interests.")
                .offset(y: 110)
                .padding()
                Spacer()
            
            if let tasks = viewModel.categorizedTasks["Others"] {
                            List(tasks, id: \.id) { task in
                                HStack {
                                    Text(task.title)
                                        .padding()
                                    Spacer()
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("You don't have any tasks related to other hobbies/activities.")
                                .padding()
                        }
                        
                        Spacer()
        }
    }
}
