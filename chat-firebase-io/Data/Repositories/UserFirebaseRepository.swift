//
//  UserFirebaseRepository.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import FirebaseFirestore

class UserFirebaseRepository: UserRepository {

    private let db = Firestore.firestore()

    func getUsers(
        onSuccess   : @escaping ([User]) -> Void,
        onError     : @escaping (Error) -> Void
    ) {

        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                onError(error)

            }

            guard let documents = snapshot?.documents else {
                onSuccess([])
                return
            }

            let users = documents.compactMap { document -> User? in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("error", error.localizedDescription)
                    return nil
                }
            }

            onSuccess(users)

        }
    }

    func updateUserProfile(
        userId      : String,
        name        : String,
        color       : String,
        onSuccess   : @escaping () -> Void,
        onError     : @escaping (String) -> Void
    ) {

        let data: [String: Any] = [
            "name": name,
            "profileColor": color,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        db.collection("users").document(userId).updateData(data) { error in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }

}

