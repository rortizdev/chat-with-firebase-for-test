//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import Firebase
import Combine

public class UserViewModel: ObservableObject {

    @Published var users        = [User]()
    @Published var currentUser  : User?
    @Published var pendingRequests: [ChatRequest] = []
    private let userUseCase     : UserUseCase
    private let chatUseCase     : ChatUseCase
    var authUseCase             : AuthUseCase
    private var listeners: [String: ListenerRegistration] = [:]

    init(userUseCase: UserUseCase, chatUseCase: ChatUseCase = ChatUseCase(chatRepository: ChatFirebaseRepository())) {
        self.userUseCase = userUseCase
        self.chatUseCase = chatUseCase
        self.authUseCase = AuthUseCase(authRepository: AuthFirebaseRepository())
        self.currentUser = authUseCase.getCurrentUser()
    }

    deinit {
        stopListening()
    }

    func sendChatRequest(to receiverId: String) {
        guard let senderId = currentUser?.id else {
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
            onSuccess   : {
                print("Solicitud enviada a \(receiverId)")
            },
            onError     : { error in
                print("Error enviando solicitud: \(error)")
            }
        )
    }

    func getAuthorizedUsers() {
        guard let currentUserId = currentUser?.id else {
            print("No hay usuario actual para obtener chats autorizados")
            return
        }

        chatUseCase.getAuthorizedChats(
            userId: currentUserId,
            onSuccess: { [weak self] authorizedUserIds in
                guard let self = self else { return }
                self.userUseCase.getUsers(
                    onSuccess: { users in
                        // Filtrar usuarios que tienen chats autorizados
                        self.users = users.filter { authorizedUserIds.contains($0.id ?? "") && $0.id != currentUserId }
                        self.checkUnreadMessages()
                    },
                    onError: { error in
                        print("Error obteniendo usuarios: \(error)")
                    }
                )
            },
            onError: { error in
                print("Error obteniendo chats autorizados: \(error)")
            }
        )
    }

    func getUsers() {
        userUseCase.getUsers(
            onSuccess: { [weak self] users in
                guard let self          = self else { return }
                guard let currentUserId = self.authUseCase.getCurrentUser()?.id else { return }
                self.users              = users.filter { $0.id != currentUserId }
                self.checkUnreadMessages()
            },
            onError: { error in
                print("Error: \(error)")
            }
        )
    }

    func updateUserProfile(
        userId      : String,
        name        : String,
        color       : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (String) -> Void
    ) {

        userUseCase.updateUserProfile(
            userId: userId,
            name: name,
            color: color,
            onSuccess: { [weak self] in
                if let index = self?.users.firstIndex(where: { $0.id == userId }) {
                    self?.users[index].name = name
                    self?.users[index].profileColor = color
                }
                onSuccess()
            },
            onError: { error in
                onError(error)
            }
        )
    }

    func logOut() throws {
        try authUseCase.logOut()
        self.currentUser = nil
    }


    private func checkUnreadMessages() {
        guard let currentUserId = authUseCase.getCurrentUser()?.id else { return }
        stopListening()

        for user in users {
            let chatId = generateChatId(between: currentUserId, and: user.id ?? "")
            listeners[chatId] = chatUseCase.listenToChatMessages(
                chatId      : chatId,
                onSuccess   : { [weak self] messages in
                    guard let self = self else { return }
                    let hasUnread = messages.contains { !$0.read && $0.senderId != currentUserId }
                    if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                        self.users[index].hasUnreadMessages = hasUnread
                    }
                },
                onError     : { error in
                    print("Error checking messages for : \(error)")
                }
            )
        }
    }

    func getPendingRequests() {
        guard let currentUserId = currentUser?.id else { return }
        chatUseCase.getPendingRequests(for: currentUserId) { [weak self] requests in
            self?.pendingRequests = requests.map { request in
                ChatRequest(
                    id          : request.documentID,
                    senderId    : request["senderId"] as! String,
                    receiverId  : request["receiverId"] as! String,
                    status      : request["status"] as! String
                )
            }
        }
    }


    func updateChatRequest(
        requestId   : String,
        status      : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        chatUseCase.updateChatRequest(
            requestId   : requestId,
            status      : status,
            onSuccess   : { [weak self] in
                self?.getPendingRequests()
                if status == "accepted" {
                    self?.getAuthorizedUsers()
                }
                onSuccess()
            },
            onError: onError
        )
    }

    func stopListening() {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }

    private func generateChatId(between userId1: String, and userId2: String) -> String {
        return [userId1, userId2].sorted().joined(separator: "_")
    }

}
