//
//  ChatFirebaseRepository.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import FirebaseFirestore

class ChatFirebaseRepository: ChatRepository {


    private let db = Firestore.firestore()

    func getPendingRequests(
        for userId  : String,
        onSuccess   : @escaping ([DocumentSnapshot]) -> Void
    ) {
        db.collection("chatRequests")
            .whereField("receiverId", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    onSuccess(documents)
                }
            }
    }

    func updateChatRequest(
        requestId   : String,
        status      : String,
        onSuccess   : @escaping () -> Void,
        onError : @escaping (Error) -> Void
    ) {
        db.collection("chatRequests")
            .document(requestId)
            .updateData(["status": status]) { error in
                if let error = error {
                    onError(error)
                } else {
                    onSuccess()
                }
            }
    }

    func checkChatRequestStatus(
        senderId    : String,
        receiverId  : String,
        onSuccess   : @escaping (String?) -> Void
    ) {

        db.collection("chatRequests")
            .whereField("senderId", isEqualTo: senderId)
            .whereField("receiverId", isEqualTo: receiverId)
            .getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    let status = document["status"] as? String
                    onSuccess(status)
                } else {
                    onSuccess(nil)
                }
            }

    }

    public func createChatRequest(
        params      : [String: Any],
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        db.collection("chatRequests").addDocument(data: params) { error in
            if let error = error {
                onError(error)
            } else {
                onSuccess()
            }
        }
    }

    public func getAuthorizedChats(
        userId      : String,
        onSuccess   : @escaping ([String]) -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        let senderQuery = db.collection("chatRequests")
            .whereField("status", isEqualTo: "accepted")
            .whereField("senderId", isEqualTo: userId)

        let receiverQuery = db.collection("chatRequests")
            .whereField("status", isEqualTo: "accepted")
            .whereField("receiverId", isEqualTo: userId)

        var authorizedIds: Set<String> = []

        senderQuery.getDocuments { snapshot, error in
            if let error = error {
                onError(error)
                return
            }
            let receiverIds = snapshot?.documents.map { $0["receiverId"] as! String } ?? []
            authorizedIds.formUnion(receiverIds)

            receiverQuery.getDocuments { snapshot, error in
                if let error = error {
                    onError(error)
                    return
                }
                let senderIds = snapshot?.documents.map { $0["senderId"] as! String } ?? []
                authorizedIds.formUnion(senderIds)
                onSuccess(Array(authorizedIds))
            }
        }
    }

    func startChat(
        chatId      : String,
        params      : ChatParams,
        onSuccess   : @escaping ((String)) -> Void,
        onError     : @escaping ((Error)) -> Void
    ) {

        let chatRef = db.collection("chats").document(chatId)

        chatRef.getDocument { (document, error) in
            if let error = error {
                onError(error)
                return
            }

            if document?.exists == true {
                // El chat ya existe, solo devolvemos el chatId
                onSuccess(chatId)
            } else {
                // Crear o actualizar con merge
                chatRef.setData(params.dictionary, merge: true) { error in
                    if let error = error {
                        onError(error)
                    } else {
                        onSuccess(chatId)
                    }
                }
            }
        }
    }

    func sendMessage(
        chatId      : String,
        params      : [String : Any],
        onSuccess   : @escaping (String) -> Void,
        onError : @escaping (any Error) -> Void
    ) {

        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: params) { error in
                if let error = error {
                    onError(error)
                } else {
                    onSuccess("Good!")
                }
            }

    }


    func listenToChatMessages(
        chatId      : String,
        onSuccess   : @escaping (([Message])) -> Void,
        onError     : @escaping ((Error)) -> Void
    ) -> ListenerRegistration {

        return db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    onError(error)
                    return
                }

                guard let _ = snapshot?.documents else {
                    onSuccess([])
                    return
                }

                let messages = snapshot?.documents.compactMap { doc -> Message? in
                    do {
                        let message = try doc.data(as: Message.self)
                        var mutableMessage = message
                        mutableMessage.id = doc.documentID
                        return mutableMessage
                    } catch {
                        print("Error decoding message: \(error)")
                        return nil
                    }
                } ?? []

                onSuccess(messages)
            }

    }

    func updateMessage(
        chatId      : String,
        messageId   : String,
        params      : [String: Any],
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document(messageId)
            .updateData(params) { error in
                if let error = error {
                    onError(error)
                } else {
                    onSuccess()
                }
            }
    }

}
