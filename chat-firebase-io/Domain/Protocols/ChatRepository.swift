//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import Firebase

protocol ChatRepository {

    func createChatRequest(
        params      : [String: Any],
        onSuccess   : @escaping (() -> Void),
        onError     : @escaping ((Error) -> Void)
    )

    func checkChatRequestStatus(
        senderId    : String,
        receiverId  : String,
        onSuccess   : @escaping (String?) -> Void
    )

    func getPendingRequests(
        for         : String,
        onSuccess   : @escaping ([DocumentSnapshot]) -> Void
    )

    func updateChatRequest(
        requestId   : String,
        status      : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    )

    func getAuthorizedChats(
        userId      : String,
        onSuccess   : @escaping (([String]) -> Void),
        onError     : @escaping ((Error) -> Void)
    ) 

    func startChat(
        chatId      : String,
        params      : ChatParams,
        onSuccess   : @escaping ((String)) -> Void,
        onError     : @escaping ((Error)) -> Void
    )

    func sendMessage(
        chatId      : String,
        params      : [String: Any],
        onSuccess   : @escaping ((String)) -> Void,
        onError     : @escaping ((Error)) -> Void
    )

    func listenToChatMessages(
        chatId      : String,
        onSuccess   : @escaping (([Message])) -> Void,
        onError     : @escaping ((Error)) -> Void
    ) -> ListenerRegistration

    func updateMessage(
        chatId      : String,
        messageId   : String,
        params      : [String: Any],
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    )

}

