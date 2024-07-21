//
//  Sports.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 25.04.2024.
//

import SwiftUI

struct Sports: View {
    @ObservedObject var viewModel: ClassifyForMeViewModel
    
    var body: some View {
        VStack {
            HeaderV2(title: "Sports", subtitle: "Stay active and enjoy various physical activities.")
                .offset(y: 110)
                .padding()
                Spacer()
            
            if let tasks = viewModel.categorizedTasks["Sports"] {
                            List(tasks, id: \.id) { task in
                                HStack {
                                    Text(task.title)
                                        .padding()
                                    Spacer()
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("You don't have any tasks related to sports.")
                                .padding()
                        }
                        
                        Spacer()
        }
       
    }
}
