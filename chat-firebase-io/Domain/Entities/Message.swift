//
//  Message.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

struct Message: Codable, Identifiable, Equatable {
    var id          : String = ""
    let text        : String
    let senderId    : String
    let timestamp   : Date
    let read        : Bool

    enum CodingKeys: String, CodingKey {
        case text
        case senderId
        case timestamp
        case read
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id           == rhs.id &&
               lhs.text         == rhs.text &&
               lhs.senderId     == rhs.senderId &&
               lhs.timestamp    == rhs.timestamp &&
               lhs.read         == rhs.read
    }
}

struct ChatParams {
    let participants: [String]
    let createdAt: Any
    let lastUpdated: Any
    let participantNames: [String: String]

    var dictionary: [String: Any] {
        [
            "participants": participants,
            "createdAt": createdAt,
            "lastUpdated": lastUpdated,
            "participantNames": participantNames
        ]
    }
}

struct ChatRequest: Identifiable {
    let id          : String
    let senderId    : String
    let receiverId  : String
    let status      : String

    // No pude usarlo, no llegue al punto de enviar mensajes
    enum ChatStatus : String {
        case pending    =  "pending"
        case accepted   =  "accepted"
        case rejected   =  "rejected"
    }

}

