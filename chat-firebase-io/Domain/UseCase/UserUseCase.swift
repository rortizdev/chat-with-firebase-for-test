//
//  File.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation

class UserUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getUsers(
        onSuccess   : @escaping ([User]) -> Void,
        onError     : @escaping (Error) -> Void
    ) {
        userRepository.getUsers(
            onSuccess   : onSuccess,
            onError     : onError
        )
    }

    func updateUserProfile(
        userId      : String,
        name        : String,
        color       : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (String) -> Void
    ) {
           userRepository.updateUserProfile(
            userId      : userId,
            name        : name,
            color       : color,
            onSuccess   : onSuccess,
            onError     : onError
           )
       }

}
