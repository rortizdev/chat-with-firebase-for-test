//
//  SwiftUIView.swift
//  chat-firebase-io
//
//  Created by Rodrigo Hernández Ortiz on 08/04/25.
//

import SwiftUI

struct EditProfile: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newName: String
    @State private var selectedColor: Color

    init(authViewModel: AuthViewModel, userViewModel: UserViewModel) {
        self.authViewModel = authViewModel
        self.userViewModel = userViewModel
        _newName = State(initialValue: authViewModel.user?.name ?? "")
        _selectedColor = State(initialValue: authViewModel.user?.color ?? Color.futuristicGreen)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nombre")) {
                    TextField("Ingresa tu nombre", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("Color del Perfil")) {
                    Picker("Selecciona un color", selection: $selectedColor) {
                        Text("Verde Futurista").tag(Color.futuristicGreen)
                        Text("Púrpura Futurista").tag(Color.futuristicPurple)
                        Text("Gris Tesla").tag(Color.teslaGray)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Editar Perfil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveChanges()
                        dismiss()
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        guard let userId = authViewModel.user?.id else { return }
        userViewModel.updateUserProfile(
            userId: userId,
            name: newName,
            color: colorToString(selectedColor),
            onSuccess: {
                authViewModel.user?.name = newName // Sincronizar con AuthViewModel
                authViewModel.user?.profileColor = colorToString(selectedColor)
            },
            onError: { error in
                print("Error: \(error)")
            }
        )
    }

    private func colorToString(_ color: Color) -> String {
        switch color {
        case Color.futuristicGreen: return "futuristicGreen"
        case Color.futuristicPurple: return "futuristicPurple"
        case Color.teslaGray: return "teslaGray"
        default: return "futuristicGreen"
        }
    }
}

