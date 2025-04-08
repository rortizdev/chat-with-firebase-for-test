//
//  Register.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI


import SwiftUI

struct Register: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Crear Cuenta")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.futuristicPurple)
                .padding(.top, 40)

            TextField("", text: $fullName, prompt: Text("Nombre Completo").foregroundColor(Color.teslaGray))
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white)
                .accentColor(Color.futuristicPurple)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.teslaGray, lineWidth: 2)
                )
                .padding(.horizontal, 40)
                .autocapitalization(.words)
                .textContentType(.name)

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
                .textContentType(.newPassword)

            SecureField("", text: $confirmPassword, prompt: Text("Confirmar Contraseña").foregroundColor(Color.teslaGray))
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white)
                .accentColor(Color.futuristicPurple)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(password == confirmPassword || confirmPassword.isEmpty ? Color.teslaGray : Color.red, lineWidth: 2)
                )
                .padding(.horizontal, 40)
                .autocapitalization(.none)
                .textContentType(.newPassword)

            if let error = viewModel.messageError {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal, 40)
            }

            Button {
                viewModel.createUser(
                    params: ["name": fullName, "email": email, "password": password]
                )
            } label: {
                Text("Crear Cuenta")
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
