import SwiftUI

struct Health: View {
    @ObservedObject var viewModel: ClassifyForMeViewModel
    var body: some View {
        VStack {
            HeaderV2(title: "Health", subtitle: "Take care of your physical and mental well-being.")
                .offset(y: 110)
                .padding()
                Spacer()
            
            // Display tasks corresponding to the "Health" category
            if let tasks = viewModel.categorizedTasks["Health"] {
                            List(tasks, id: \.id) { task in
                                HStack {
                                    Text(task.title)
                                        .padding()
                                    Spacer()
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("You don't have any tasks related to health.")
                                .padding()
                        }
                        
                        Spacer()
                .padding()
        }

    }
}

struct Health_Previews: PreviewProvider {
    static var previews: some View {
        Health(viewModel: ClassifyForMeViewModel(userId: "f6S6M0HllnUufAiqMvvkrxri7X93"))
    }
}
