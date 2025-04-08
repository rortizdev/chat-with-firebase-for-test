//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct UserRow: View {
    let user: User

    var body: some View {
        HStack {
            Text(initial)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.futuristicPurple)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))

            Text(user.name.isEmpty ? user.email : user.name)
                .font(.body)

            Spacer()

            if user.hasUnreadMessages == true {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color.futuristicPurple)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
            }
        }
        .padding(.vertical, 8)
    }

    private var initial: String {
        let displayText = user.name.isEmpty ? user.email : user.name
        return String(displayText.prefix(1)).uppercased()
    }
}
