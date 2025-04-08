//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

class AuthUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func getCurrentUser() -> User? {
        authRepository.getCurrentUser()
    }

    func signIn(
        email       : String,
        password    : String,
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    ) {
        authRepository.signIn(
            email       : email,
            password    : password,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func signUp(
        params      : [String: String],
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    ) {
        authRepository.signUp(
            params      : params,
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func logOut() throws {
        try authRepository.logOut()
    }
}
