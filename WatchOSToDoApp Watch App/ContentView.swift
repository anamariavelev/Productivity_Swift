import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject var watchConnector = WatchConnector()

    var body: some View {
        VStack {
            Text("Tasks:")
                .padding(.top)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading) // Align title to the left
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(watchConnector.receivedMessages, id: \.self) { msg in
                        HStack {
                            Text(msg)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading) // Ensure text is left-aligned
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.vertical, 2)
                            
                            Button(action: {
                                watchConnector.deleteTask(title: msg)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            .frame(width: 44, height: 44) // Smaller button size
                            .padding()
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            watchConnector.activateSession()
        }
    }
}

class WatchConnector: NSObject, ObservableObject, WCSessionDelegate {
    var wcSession: WCSession?
    @Published var receivedMessages: [String] = []

    override init() {
        super.init()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession?.delegate = self
        }
        loadTasks()
    }

    func activateSession() {
        self.wcSession?.activate()
    }

    func deleteTask(title: String) {
        guard let session = wcSession, session.isReachable else {
            print("WCSession is not reachable")
            return
        }
        
        let message = ["deleteTitle": title]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending delete message: \(error.localizedDescription)")
        }
        
        // Update local list immediately for a better user experience
        if let index = receivedMessages.firstIndex(of: title) {
            receivedMessages.remove(at: index)
            saveTasks()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("activationDidCompleteWith activationState: \(activationState) error: \(String(describing: error))")
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let titles = applicationContext["titles"] as? [String] {
            DispatchQueue.main.async {
                self.receivedMessages = titles
                self.saveTasks()
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let titles = message["titles"] as? [String] {
            DispatchQueue.main.async {
                self.receivedMessages = titles
                self.saveTasks()
            }
        }
    }

    // Save tasks to UserDefaults
    func saveTasks() {
        UserDefaults.standard.set(receivedMessages, forKey: "SavedTasks")
    }

    // Load tasks from UserDefaults
    func loadTasks() {
        if let savedTasks = UserDefaults.standard.array(forKey: "SavedTasks") as? [String] {
            self.receivedMessages = savedTasks
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
