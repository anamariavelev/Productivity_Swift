//
//  ToDoListItemView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI

struct ToDoListItemView: View {
    let item: ToDoListItem
    @ObservedObject var viewModel = ToDoListItemViewViewModel()
    @State private var isEditing = false
    @StateObject var editViewModel: EditItemViewModel
    @State private var showingEditItemView = false
    
    
    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode
    var ribbonthemeColor: Color {
        colorScheme == .light ? .green : .orange
    }
    
    init(item: ToDoListItem) {
        self.item = item
        self._editViewModel = StateObject(wrappedValue: EditItemViewModel(item: item))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .bold()
                    .onTapGesture {
                        isEditing.toggle()
                        showingEditItemView = true
                    }
                
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            
            Button(action: {
                viewModel.toggleIsDone(item: item)
                
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(ribbonthemeColor)
            }
        }
        .fullScreenCover(isPresented: $isEditing, content: {
            NavigationStack {
                EditItemView(item: item, isPresented: $isEditing, showingEditItemView: $showingEditItemView, viewModel: editViewModel, onDismiss: {
                    //editing mode to false when the EditItemView is dismissed
                    isEditing = false
                })
            }
        })

    }
}




#Preview {
    ToDoListItemView(item: .init(id: "123", title: "Title", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false))
}
