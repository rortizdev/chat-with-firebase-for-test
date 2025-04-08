//
//  AuthFirebaseRepository.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthFirebaseRepository : AuthRepository {

    func getCurrentUser() -> User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }

        return User(
            id      : user.uid,
            email   : user.email ?? "",
            name    : "",
            createAt: Date()
        )
    }

    func signIn(
        email       : String,
        password    : String,
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    ) {

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in

            if let error = error  {
                onError(error.localizedDescription)
                return
            }

            guard let user = authResult?.user else {
                return
            }
            onSuccess(
                User(
                    id      : user.uid,
                    email   : user.email ?? "",
                    name    : "",
                    createAt: Date()
                )
            )
        }


    }


    func signUp(
        params      : [String: String],
        onSuccess   : @escaping ((User) -> Void),
        onError     : @escaping ((String) -> Void)
    ) {

        guard let email     = params["email"] else {
            onError("No existe email")
            return
        }
        guard let password  = params["password"] else {
            onError("No existe password")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult,
            authError) in

            if let authError = authError  {
                onError(authError.localizedDescription)
                return
            }

            guard let user = authResult?.user else { return }


            let db      = Firestore.firestore()
            let name    = params["name"] ?? ""

            let userData = [
                "uid"       : user.uid ,
                "name"      : name,
                "email"     : user.email ?? "",
                "createAt"  : FieldValue.serverTimestamp()
            ]

            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    onError(error.localizedDescription)
                } else {
                    onSuccess(
                        User(id: user.uid, email: user.email ?? "", name: "", createAt: Date()))
                }
            }
        }
    }

    func logOut() throws {
        try Auth.auth().signOut()
    }

}

