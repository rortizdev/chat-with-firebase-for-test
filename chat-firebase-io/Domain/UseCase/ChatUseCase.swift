//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import Firebase

class ChatUseCase {

    private let chatRepository: ChatRepository

    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }


    func createChatRequest(
        params      : [String: Any],
        onSuccess   : @escaping (() -> Void),
        onError     : @escaping ((Error) -> Void)
    ) {
        chatRepository.createChatRequest(
            params      : params,
            onSuccess   : onSuccess,
            onError: onError
        )
    }

    func checkChatRequestStatus(
        senderId    : String,
        receiverId  : String,
        onSuccess   : @escaping (String?) -> Void
    ) {
        chatRepository.checkChatRequestStatus(
            senderId    : senderId,
            receiverId  : receiverId,
            onSuccess   : onSuccess
        )
    }

    func getAuthorizedChats(
        userId      : String,
        onSuccess   : @escaping (([String]) -> Void),
        onError     : @escaping ((Error) -> Void)
    ) {
        chatRepository.getAuthorizedChats(
            userId      : userId,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func getPendingRequests(
        for userId  : String,
        onSuccess   : @escaping ([DocumentSnapshot]) -> Void
    ) {
        chatRepository.getPendingRequests(
            for         : userId,
            onSuccess   : onSuccess
        )
    }

    func updateChatRequest(
        requestId   : String,
        status      : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        chatRepository.updateChatRequest(
            requestId   : requestId,
            status      : status,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func startChat(
        chatId      : String,
        params      : ChatParams,
        onSuccess   : @escaping ((String) -> Void),
        onError     : @escaping ((Error) -> Void)
    ) {

        chatRepository.startChat(
            chatId      : chatId,
            params      : params,
            onSuccess   : onSuccess,
            onError     : onError
        )

    }

    func sendMessage(
        chatId      : String,
        params      : [String: Any],
        onSuccess   : @escaping ((String) -> Void),
        onError     : @escaping ((Error) -> Void)
    ) {
        chatRepository.sendMessage(
            chatId      : chatId,
            params      : params,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func listenToChatMessages(
        chatId      : String,
        onSuccess   : @escaping (([Message]) -> Void),
        onError     : @escaping ((Error) -> Void)
    ) -> ListenerRegistration {

        chatRepository.listenToChatMessages(
            chatId      : chatId,
            onSuccess   : onSuccess,
            onError     : onError
        )

    }

    func updateMessage(
        chatId      : String,
        messageId   : String,
        params      : [String: Any],
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        chatRepository.updateMessage(
            chatId      : chatId,
            messageId   : messageId,
            params      : params,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

}

