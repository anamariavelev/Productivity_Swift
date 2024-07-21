////
////  CategoryViewModel.swift
////  ToDoApp
////
////  Created by Ana Maria Velev on 25.04.2024.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//import SwiftUI
//import FirebaseFirestore
//
//class CategoryViewModel: ObservableObject {
//    @Published var categorizedTasks: [String: [ToDoListItem]] = [:]
//
//    func classifyAndSaveTask(task: ToDoListItem) {
//        do {
//            
//            // Use ML model to classify the task
//            let predictedCategory = try predictCategory(for: task.title)
//
//            // Create a new collection for the predicted category if it doesn't exist yet
//            let db = Firestore.firestore()
//            guard let uId = Auth.auth().currentUser?.uid else {
//                return
//            }
//
//            let categoryCollectionRef = db.collection("users")
//                .document(uId)
//                .collection("options")
//                .document(uId)
//                .collection(predictedCategory)
//
//            // Save task to the predicted category
//            let documentRef = categoryCollectionRef.document(task.id)
//            documentRef.setData(task.asDictionary())
//
//            // Update categorizedTasks dictionary with tasks for the predicted category
//            if categorizedTasks[predictedCategory] == nil {
//                categorizedTasks[predictedCategory] = [task]
//            } else {
//                categorizedTasks[predictedCategory]?.append(task)
//            }
//        } catch {
//            print("Error predicting category: \(error)")
//        }
//    }
//
//    func predictCategory(for text: String) throws -> String {
//        let input = LicentaInput(text: text)
//        let model = try Licenta(contentsOf: Licenta.urlOfModelInThisBundle)
//        let output = try model.prediction(input: input)
//        return output.label
//    }
//}
//
