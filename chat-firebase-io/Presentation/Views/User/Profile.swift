//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode

    private var userInitial: String {
        let displayText = authViewModel.user?.name.isEmpty ?? true ? authViewModel.user?.email ?? "" : authViewModel.user?.name ?? ""
        return String(displayText.prefix(1)).uppercased()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                }

                Text("Perfil")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(Color.futuristicPurple)

            VStack(spacing: 20) {
                Text(userInitial)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(authViewModel.user?.color ?? Color.futuristicPurple)
                    .clipShape(Circle())
                    .padding(.top, 20)

                Text(authViewModel.user?.email ?? "N/A")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                Button(action: {
                    isEditing = true
                }) {
                    Text("Editar Perfil")
                        .font(.headline)
                        .foregroundColor(Color.futuristicPurple)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    authViewModel.logOut()

                }) {
                    Text("Cerrar Sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.futuristicPurple)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isEditing) {
            EditProfile(
                authViewModel: authViewModel,
                userViewModel: userViewModel
            )
        }
    }
}
