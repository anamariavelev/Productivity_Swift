//
//  LearningView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 16.03.2024.
//

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI()
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct LearningView: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode
    
    var themeColor: Color {
        colorScheme == .light ? .green : .yellow
    }
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatController.messages) {
                    message in
                    MessageView(message: message)
                        .padding(5)
                }
            }
            Divider()
            HStack {
                TextField(" Type your question here...", text: self.$string, axis: .vertical)
                //.padding(15)
                    .frame(width: 350, height: 40, alignment: .center)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                Button {
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(themeColor)
                }

            }
            .padding()
            .offset(y: 5)

        }
    }
}

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LearningView()
}
