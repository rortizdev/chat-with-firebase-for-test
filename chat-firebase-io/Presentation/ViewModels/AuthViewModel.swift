//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

class AuthViewModel: ObservableObject {

    @Published var user         : User?
    @Published var messageError : String?
    private let authUseCase     : AuthUseCase

    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        self.getCurrentUser()
    }

    func getCurrentUser() {
        self.user = authUseCase.getCurrentUser()
    }

    func logIn(_ email: String, _ password: String) {
        authUseCase.signIn(
            email       : email,
            password    : password,
            onSuccess   : { user in
                self.user = user
            },
            onError     : { error in
                self.messageError = error.localizedCapitalized
            }
        )
    }

    func createUser(params: [String: String]) {
        authUseCase.signUp(
            params      : params,
            onSuccess   : { user in
                self.user = user
            },
            onError     : { error in
                self.messageError = error.localizedCapitalized
            }
        )
    }

    func logOut() {
        do {
            try authUseCase.logOut()
            self.user = nil
        } catch {
            self.messageError = error.localizedDescription
        }
    }

}

