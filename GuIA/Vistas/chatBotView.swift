//
//  chatBotView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI


struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct chatBotView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hola soy tu asistente, ¿en qué te puedo ayudar?", isUser: false)
    ]
    @State private var currentInput: String = ""
    
    var body: some View {
        ZStack {
            // Fondo igual que homeView
            Color("ColorFondos").ignoresSafeArea()
            
            VStack {
                // Header
                Text("Tu concierge IA")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("HomeButtons"))
                    .foregroundColor(Color("ColorFondos"))
                
                // Mensajes
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(messages) { msg in
                            HStack {
                                if msg.isUser { Spacer() }
                                
                                ChatBubble(text: msg.text, isUser: msg.isUser)
                                
                                if !msg.isUser { Spacer() }
                            }
                        }
                    }
                    .padding(10)
                }
                
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        TextField("Escribe tu mensaje...", text: $currentInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Enviar") {
                            sendMessage()
                        }
                        .padding(.horizontal)
                        .foregroundColor(Color("ColorFondos"))
                        .background(Color("HomeButtons"))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color("ColorFondos"))
                    .padding(.bottom, 80) // 👈 margen extra por tu barra personalizada
                }
            }
        }
    }
    
    func sendMessage() {
        guard !currentInput.isEmpty else { return }
        messages.append(ChatMessage(text: currentInput, isUser: true))
        currentInput = ""
        
        // Respuesta simulada
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(ChatMessage(text: "Estoy procesando tu solicitud...", isUser: false))
        }
    }
}

struct ChatBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        ZStack {
            // Rectángulo exterior
            Rectangle()
                .foregroundColor(Color("HomeButtons"))
                .frame(width: 250, height: 100)
                .cornerRadius(20)
                .overlay(
                    // Rectángulo interior
                    Rectangle()
                        .frame(width: 230, height: 80)
                        .foregroundColor(Color("ColorFondos"))
                        .cornerRadius(20)
                        .overlay(
                            Text(text)
                                .foregroundColor(Color("HomeButtons"))
                                .bold()
                                .font(.system(size: 16))
                                .padding()
                                .multilineTextAlignment(.leading)
                        )
                )
        }
    }
}

#Preview {
    chatBotView()
}
