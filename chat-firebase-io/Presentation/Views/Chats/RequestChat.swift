//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct RequestChat: View {
    @ObservedObject var usersViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(usersViewModel.users) { user in
                    Button(action: {
                        usersViewModel.sendChatRequest(to: user.id ?? "")
                        dismiss()
                    }) {
                        Text(user.email)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Solicitar Chat")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .task {
                usersViewModel.getUsers()
            }
        }
    }
}
