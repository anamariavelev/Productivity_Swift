//
//  Food & Diet.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 25.04.2024.
//

import SwiftUI

struct Food___Diet: View {
    
    @ObservedObject var viewModel: ClassifyForMeViewModel

    var body: some View {
        VStack{
        HeaderV2(title: "Food & Diet", subtitle: "Explore healthy eating habits and nutritious recipes.")
            .offset(y: 110)
            .padding()
            Spacer()
            
            if let tasks = viewModel.categorizedTasks["Food & Diet"] {
                            List(tasks, id: \.id) { task in
                                HStack {
                                    Text(task.title)
                                        .padding()
                                    Spacer()
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("You don't have any tasks related to food & diet.")
                                .padding()
                        }
                        
                        Spacer()
        }
        
    }
}



struct Food___Diet_Previews: PreviewProvider {
    static var previews: some View {
        Food___Diet(viewModel: ClassifyForMeViewModel(userId: "f6S6M0HllnUufAiqMvvkrxri7X93"))
    }
}
