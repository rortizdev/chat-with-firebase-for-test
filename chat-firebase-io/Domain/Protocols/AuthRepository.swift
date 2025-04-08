//
//  AuthRe`psit.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

protocol AuthRepository {

    func getCurrentUser() -> User?

    func signIn(
        email       : String,
        password    : String,
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    )

    func signUp(
        params      : [String: String],
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    )

    func logOut() throws
}

