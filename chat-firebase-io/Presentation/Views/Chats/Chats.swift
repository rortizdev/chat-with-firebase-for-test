//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct Chats: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var usersViewModel: UserViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Chats")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                    Spacer()
                    NavigationLink(destination: Profile()) {
                        Text(currentUserInitial(from: authViewModel.user))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(authViewModel.user?.color ?? Color.futuristicPurple)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    }
                }
                .padding()
                .background(Color.futuristicPurple)

                List(usersViewModel.users) { user in
                    NavigationLink(destination: ChatView(recipient: user)) {
                        UserRow(user: user)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: .infinity)

                Spacer()
            }
            .task({
                usersViewModel.getUsers() 
            })
            .navigationBarHidden(true)
        }
    }

    private func currentUserInitial(from user: User?) -> String {
        let displayText = user?.name.isEmpty ?? true ? user?.email ?? "" : user?.name ?? ""
        return String(displayText.prefix(1)).uppercased()
    }
}
