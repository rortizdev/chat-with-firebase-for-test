//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

protocol UserRepository {

    func getUsers(
        onSuccess   : @escaping ([User]) -> Void,
        onError     : @escaping (Error) -> Void
    )

    func updateUserProfile(
        userId      : String,
        name        : String,
        color       : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (String) -> Void
    )

}
