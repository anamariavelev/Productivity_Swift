//
//  ToDoListView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/options/\(userId)/todos"
        )
        
        self._viewModel = StateObject(
            wrappedValue: ToDoListViewViewModel(userId: userId)
        )
    }

    var body: some View {
        NavigationStack{
            VStack{
                List(items){ item in
                    ToDoListItemView(item: item)
                        .swipeActions{
                            Button("Delete"){
                                viewModel.deleteItem(title: item.title)
                            }
                            .tint(.red)
                        }
                }
                .padding()
                .listStyle(PlainListStyle())
            }
            .navigationTitle("To do list")
            .toolbar{
                Button{
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView){
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
            .onChange(of: items) { _ in
                viewModel.sendMessage()
            }
        }
    }
}
