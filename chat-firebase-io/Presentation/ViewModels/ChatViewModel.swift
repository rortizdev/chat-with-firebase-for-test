//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import Firebase
import Combine

class ChatViewModel: ObservableObject {

    @Published var chatId       : String?
    @Published var requestStatus: String?   = nil
    @Published var messages     : [Message] = []
    @Published var isLoading                = false
    @Published var error        : Error?

    private var listener: ListenerRegistration?
    private let chatUseCase: ChatUseCase
    let authUseCase: AuthUseCase

    init(chatUseCase: ChatUseCase,
         authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthFirebaseRepository())) {
        self.chatUseCase = chatUseCase
        self.authUseCase = authUseCase
    }

    deinit {
        stopListening()
    }

    func sendChatRequest(to receiverId: String) {
        guard let senderId = authUseCase.getCurrentUser()?.id else {
            return
        }

        let params: [String: Any] = [
            "senderId"  : senderId,
            "receiverId": receiverId,
            "status"    : "pending",
            "timestamp" : FieldValue.serverTimestamp()
        ]
        chatUseCase.createChatRequest(
            params      : params,
            onSuccess   : { [weak self] in
                self?.checkChatRequestStatus(senderId: senderId, receiverId: receiverId)
            },
            onError     : { error in
                print("Error enviando solicitud: \(error)")
            }
        )
    }

    func checkChatRequestStatus(
        senderId    : String,
        receiverId  : String
    ) {
        chatUseCase.checkChatRequestStatus(
            senderId: senderId,
            receiverId: receiverId,
            onSuccess: { [weak self] status in
                DispatchQueue.main.async {
                    print("Estado recibido: \(String(describing: status))")
                    self?.requestStatus = status
                    if status == "accepted", let chatId = self?.chatId {
                        self?.listenToChatMessages(chatId)
                    }
                }
            }
        )
    }

    func updateChatRequest(
        requestId   : String,
        status      : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        chatUseCase.updateChatRequest(
            requestId: requestId,
            status: status,
            onSuccess: onSuccess,
            onError: onError
        )
    }


    func startChat(with recipient: User) {
        guard let recipientId = recipient.id,
              let currentUserId = authUseCase.getCurrentUser()?.id else {
            error = NSError(domain: "ChatError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])
            return
        }

        isLoading = true
        let chatId = generateChatId(between: currentUserId, and: recipientId)

        let params = ChatParams(
            participants: [currentUserId, recipientId],
            createdAt: FieldValue.serverTimestamp(),
            lastUpdated: FieldValue.serverTimestamp(),
            participantNames: [
                currentUserId: authUseCase.getCurrentUser()?.name ?? "Usuario",
                recipientId: recipient.name
            ]
        )

        chatUseCase.startChat(
            chatId: chatId,
            params: params,
            onSuccess: { [weak self] chatId in
                print("StartCHAT", chatId)
                self?.isLoading = false
                self?.chatId    = chatId
                self?.listenToChatMessages(chatId)
                self?.markMessagesAsRead(chatId: chatId)
            },
            onError: { [weak self] error in
                self?.isLoading = false
                self?.error     = error
                print("Error starting chat: \(error.localizedDescription)")
            }
        )
    }

    func sendMessage(chatId: String, messageText: String) {
        guard !messageText.isEmpty,
              let currentUserId = authUseCase.getCurrentUser()?.id else {
            return
        }

        let params: [String: Any] = [
            "text"      : messageText,
            "senderId"  : currentUserId,
            "timestamp" : FieldValue.serverTimestamp(),
            "read"      : false
        ]

        chatUseCase.sendMessage(
            chatId: chatId,
            params: params,
            onSuccess: { _ in
            },
            onError: { [weak self] error in
                self?.error = error
                print("Error sending message: \(error.localizedDescription)")
            }
        )
    }

    func listenToChatMessages(_ chatId: String) {
        stopListening()

        listener = chatUseCase.listenToChatMessages(
            chatId      : chatId,
            onSuccess   : { [weak self] messages in
                self?.messages = messages.sorted { $0.timestamp < $1.timestamp }
            },
            onError     : { [weak self] error in
                self?.error = error
                print("Error listening to messages: \(error.localizedDescription)")
            }
        )
    }

    private func markMessagesAsRead(chatId: String) {
        guard let currentUserId = authUseCase.getCurrentUser()?.id else { return }
        let unreadMessages      = messages.filter { !$0.read && $0.senderId != currentUserId }
        print("Marcando \(unreadMessages.count) mensajes como leídos en chat \(chatId)")

        for message in unreadMessages {
            chatUseCase.updateMessage(
                chatId      : chatId,
                messageId   : message.id,
                params      : ["read": true],
                onSuccess   : {
                    print("Mensaje \(message.id) marcado como leído")
                },
                onError     : { error in
                    print("Error marcando mensaje: \(error)")
                }
            )
        }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }


    private func generateChatId(between userId1: String, and userId2: String) -> String {
        assert(!userId1.isEmpty && !userId2.isEmpty, "Los IDs de usuario no pueden estar vacíos")
        return [userId1, userId2].sorted().joined(separator: "_")

    }
}

