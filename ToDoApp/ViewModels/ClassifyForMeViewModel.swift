import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import CoreML

class ClassifyForMeViewModel: ObservableObject {
    @Published var categorizedTasks: [String: [ToDoListItem]] = [:]
    private var processedTaskIDs: Set<String> = []  // Track processed task IDs
    let db = Firestore.firestore()
    private let userId: String
    private var tasksFetched = false

    @Published var categories: [(String, String)] = [
        ("Food & Diet", "Explore healthy eating habits and nutritious recipes."),
        ("Health", "Take care of your physical and mental well-being."),
        ("Sports", "Stay active and enjoy various physical activities."),
        ("Work & Education", "Focus on career growth and lifelong learning."),
        ("Others", "Discover hobbies, social activities, and personal interests.")
    ]

    init(userId: String) {
        self.userId = userId
    }

    func fetchAndCategorizeTasks() {
        guard !userId.isEmpty else {
            print("User ID is empty. Cannot fetch and categorize tasks.")
            return
        }
        
        print("Fetching and categorizing tasks...")
        
        db.collection("users")
            .document(userId)
            .collection("options")
            .document(userId)
            .collection("todos")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return // Exit early if error
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("No documents found")
                    return
                }
                
                var newTasks: [ToDoListItem] = []
                for document in querySnapshot.documents {
                    // Create a DocumentSnapshot instance from the Firestore document
                    let documentSnapshot = document
                    // Decode the data into ToDoListItem model
                    if let task = try? documentSnapshot.data(as: ToDoListItem.self) {
                        if !self.processedTaskIDs.contains(task.id) {
                            newTasks.append(task)
                            self.processedTaskIDs.insert(task.id) // Mark task as processed
                        }
                    }
                }
                
                print("New tasks to be categorized: \(newTasks)")
                
                self.categorizeTasks(newTasks)// Categorize new tasks using ML model
            }
    }
    
    func fetchAndCategorizeTasksIfNeeded() {
        fetchAndCategorizeTasks()
    }

    func categorizeTasks(_ tasks: [ToDoListItem]) {
        print("Categorizing tasks...")
        
        let mlModel = Licenta()// Initialize the ML model
        
        for task in tasks {
            do {
                print("Processing task: \(task.title)")
                let inputText = LicentaInput(text: task.title) // Prepare input for the model
                let output = try mlModel.prediction(input: inputText) // Perform prediction
                let predictedCategory = output.label //Access the predicted category from the output; property name representing the category
                
                print("ML prediction for task '\(task.title)': \(predictedCategory)")
                
                if categorizedTasks[predictedCategory] == nil {
                    categorizedTasks[predictedCategory] = []
                }
                categorizedTasks[predictedCategory]?.append(task)
            } catch {
                print("Error predicting category for task '\(task.title)': \(error)")
                categorizedTasks["Others", default: []].append(task)
            }
        }
        
        print("Categorized tasks: \(categorizedTasks)")
        DispatchQueue.main.async {
            // UI updates on the main thread
            self.objectWillChange.send()
        }
    }
}
