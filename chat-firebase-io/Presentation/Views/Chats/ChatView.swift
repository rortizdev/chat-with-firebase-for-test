//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct ChatView: View {
    let recipient: User
    @StateObject private var chatViewModel  : ChatViewModel
    @EnvironmentObject var usersViewModel   : UserViewModel
    @State private var messageText = ""
    @Environment(\.presentationMode) var presentationMode

    private var bottomID: String { "bottom" }

    init(recipient: User) {
        self.recipient = recipient
        _chatViewModel = StateObject(wrappedValue: ChatViewModel(
            chatUseCase: ChatUseCase(
                chatRepository: ChatFirebaseRepository()
            )
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            messagesListView
            messageInputView
        }
        .onAppear {
            print("ChatView apareció para \(recipient.id ?? "sin ID")")

            chatViewModel.startChat(with: recipient)
        }
        .onDisappear {
            chatViewModel.stopListening()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews
extension ChatView {
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            }

            Text(recipient.name)
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .background(Color.futuristicPurple)
    }

    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(chatViewModel.messages) { message in
                        MessageBubble(message: message,
                                      isCurrentUser: message.senderId == chatViewModel.authUseCase.getCurrentUser()?.id)
                        .id(message.id)
                    }

                    Color.clear
                        .frame(height: 1)
                        .id(bottomID)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .onChange(of: chatViewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
            }
        }
    }

    private func messageRow(for message: Message) -> some View {
        let isCurrentUser = message.senderId == chatViewModel.authUseCase.getCurrentUser()?.id
        return MessageBubble(
            message: message,
            isCurrentUser: isCurrentUser
        )
        .id(message.id)
        .transition(.asymmetric(
            insertion: .move(edge: isCurrentUser ? .trailing : .leading),
            removal: .opacity
        ))
    }

    private var bottomScrollAnchor: some View {
        Color.clear
            .frame(height: 1)
            .id(bottomID)
    }

//    private var messageInputView: some View {
//        Group {
//            if let status = chatViewModel.requestStatus {
//                if status == "accepted" {
//                    HStack {
//                        TextField("Escribe un mensaje...", text: $messageText)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.leading)
//                        sendMessageButton
//                    }
//                } else if status == "pending" {
//                    Text("Solicitud enviada, esperando aprobación")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                } else {
//                    VStack {
//                        Text("Necesitas enviar una solicitud para chatear")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                        Button("Enviar Solicitud") {
//                            chatViewModel.sendChatRequest(to: recipient.id ?? "")
//                        }
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.futuristicPurple)
//                        .cornerRadius(10)
//                    }
//                }
//            } else {
//                ProgressView()
//            }
//        }
//        .padding(.bottom)
//        .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom))
//    }

    private var messageInputView: some View {

        HStack {
            TextField("Escribe un mensaje...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading)

            sendMessageButton
        }
        .padding(.bottom)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom))
    }

    private var sendMessageButton: some View {
        Button(action: sendMessage) {
            Image(systemName: "paperplane.fill")
                .padding(8)
                .background(Color.futuristicPurple)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .padding(.trailing)
        .disabled(messageText.isEmpty)
    }
}


extension ChatView {
    private func sendMessage() {
        guard let chatId = chatViewModel.chatId, !messageText.isEmpty else { return }
        chatViewModel.sendMessage(chatId: chatId, messageText: messageText)
        messageText = ""
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(bottomID, anchor: .bottom)
        }
    }

}
