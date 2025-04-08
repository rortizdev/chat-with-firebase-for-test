//
//  chat_firebase_ioApp.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct chat_firebase_ioApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authViewModel = AuthViewModel(authUseCase: AuthUseCase(authRepository: AuthFirebaseRepository()))
    @StateObject var userViewModel = UserViewModel(userUseCase: UserUseCase(userRepository: UserFirebaseRepository()))

    var body: some Scene {
        WindowGroup {
            if let _ = authViewModel.user {
                Chats(usersViewModel: userViewModel)
            } else {
                Welcome(viewModel: authViewModel)
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(userViewModel)
    }
}
