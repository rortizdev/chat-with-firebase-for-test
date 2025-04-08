//
//  ContentView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct Welcome: View {

    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(spacing: 40) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    VStack(spacing: 15) {
                        Text("Bienvenido al Chat")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("Conéctate en tiempo real con estilo")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)


                        NavigationLink(destination: Login(viewModel: viewModel)) {
                            Text("Iniciar Sesión")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundColor(Color.futuristicPurple)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.futuristicPurple, lineWidth: 2)
                                )
                                .cornerRadius(20)
                        }

                        NavigationLink {
                            Register(viewModel: viewModel)
                        } label: {
                            Text("Crear cuenta")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.futuristicPurple)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.futuristicPurple, lineWidth: 2)
                                )
                                .cornerRadius(20)
                        }
                    }
                    .padding()

                }
            }
            .navigationBarHidden(true)
        }
    }
}
