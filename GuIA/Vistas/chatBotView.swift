//
//  chatBotView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI

struct chatBotView: View
{
    // Usamos @StateObject para crear y mantener viva una instancia del ViewModel.
    @StateObject private var viewModel = ChatViewModel()
    
    @State private var userInput: String = ""
    
    var body: some View {
        // ✅ Para que el título se vea correctamente, la vista debe estar dentro de un NavigationView
        NavigationView
        {
            VStack(spacing: 0) { // Usamos spacing: 0 para controlar el layout precisamente
                
                // MARK: - Lista de Mensajes
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        // Usamos un LazyVStack para mejorar el rendimiento con muchos mensajes
                        LazyVStack {
                            ForEach(viewModel.conversation) { msg in
                                MessageView(message: msg)
                                    .id(msg.id)
                            }
                        }
                    }
                    // ✅ Sintaxis moderna y limpia para el onChange
                    .onChange(of: viewModel.conversation) {
                        guard let lastMessage = viewModel.conversation.last else { return }
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                
                // MARK: - Indicador de Carga
                if viewModel.isLoading {
                    ProgressView("Esperando respuesta...")
                        .padding(.top, 10)
                }
                
                // MARK: - Campo de Entrada y Botón
                HStack {
                    TextField("Escribe tu mensaje...", text: $userInput)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isLoading)
                    
                    Button(action: {
                        viewModel.sendMessage(userInput)
                        userInput = ""
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(userInput.isEmpty ? .gray : .blue) // Color dinámico
                    }
                    .disabled(userInput.isEmpty || viewModel.isLoading)
                }
                .padding()
                .padding(.bottom, 50) // ✅ Respetamos un padding inferior generoso
            }
            .navigationTitle("Asistente Virtual")
            .navigationBarTitleDisplayMode(.inline) // Título más compacto
        }
    }
}

// MARK: - Vista de un solo mensaje
// Tu MessageView está perfecta, no necesita cambios.
struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.message)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            } else {
                Text(message.message)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    chatBotView()
}
