//
//  User.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import SwiftUI

struct User: Codable, Identifiable {
    @DocumentID var id      : String?
    let email               : String
    var name                : String
    let createAt            : Date
    var hasUnreadMessages   : Bool?
    var profileColor        : String?

    var color: Color {
        switch profileColor {
        case "futuristicGreen"  : return Color.futuristicGreen
        case "futuristicPurple" : return Color.futuristicPurple
        case "teslaGray"        : return Color.teslaGray
        case nil, _             : return Color.futuristicPurple
        }
    }

    init(
        id                  : String,
        email               : String,
        name                : String,
        createAt            : Date,
        hasUnreadMessages   : Bool? = nil,
        profileColor        : String? = nil
    ) {
        self.id                 = id
        self.email              = email
        self.name               = name
        self.createAt           = createAt
        self.hasUnreadMessages  = hasUnreadMessages
        self.profileColor       = profileColor
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createAt
        case hasUnreadMessages
        case profileColor
    }
}
