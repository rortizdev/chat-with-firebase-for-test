//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }

            messageContent

            if !isCurrentUser {
                Spacer()
            }
        }
    }

    private var messageContent: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
            Text(message.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(messageBackground)
                .foregroundColor(messageForeground)
                .cornerRadius(12)
                .contextMenu { contextMenu }

            messageTimestamp
        }
    }

    private var messageBackground: some View {
        isCurrentUser ? Color.futuristicPurple : Color(.systemGray5)
    }

    private var messageForeground: Color {
        isCurrentUser ? .white : .primary
    }

    private var messageTimestamp: some View {
        Text(message.timestamp, style: .time)
            .font(.caption2)
            .foregroundColor(.gray)
    }

    private var contextMenu: some View {
        Button(action: copyMessage) {
            Label("Copiar", systemImage: "doc.on.doc")
        }
    }

    private func copyMessage() {
        UIPasteboard.general.string = message.text
    }

}
