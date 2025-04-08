//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {

            Text("Iniciar Sesión")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.futuristicPurple)
                .padding(.top, 50)

            TextField("", text: $email, prompt: Text("Correo Electrónico").foregroundColor(Color.teslaGray))
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white)
                .accentColor(Color.futuristicPurple)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.teslaGray, lineWidth: 2)
                )
                .padding(.horizontal, 40)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)

            SecureField("", text: $password, prompt: Text("Contraseña").foregroundColor(Color.teslaGray))
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white) 
                .accentColor(Color.futuristicPurple)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.teslaGray, lineWidth: 2)
                )
                .padding(.horizontal, 40)
                .autocapitalization(.none)
                .textContentType(.password)

            if let errorMessage = viewModel.messageError {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal, 40)
            }

            Button {
                viewModel.logIn(email, password)
            } label: {
                Text("Iniciar Sesión")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.futuristicPurple : Color.teslaGray)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isFormValid ? Color.futuristicPurple : Color.teslaGray, lineWidth: 2)
                    )
                    .cornerRadius(20)
            }
            .padding(.horizontal, 40)
            .disabled(!isFormValid)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
