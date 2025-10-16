//
//  chatBotModel.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 11/10/25.
//

import Foundation
import FirebaseAI

//tipo de dato para definir los roles en el chat
enum ChatRole
{
    case user
    case chatAI
}


//estructura que seguira cada objeto mensaje creado en el chat
struct Message: Identifiable, Equatable //estructura que seguira cada objeto mensaje creado en el chat
{
    /*
     dato curioso el protocolo Identifiable forzosamente me pide que exista ina variable llamada "id" de tipo Int.
     */
    let id = UUID() //generamos un id único para cada mensaje
    var role:ChatRole // para distinguir quien habla
    var message:String //la variable message guardará el contenido del mensaje
}

@MainActor
class ChatViewModel: ObservableObject
{
    @Published var conversation: [Message] = []
    @Published var isLoading = false

    private let generativeModel: GenerativeModel

    init() {
        // ✅ CORRECCIÓN FINAL: Usando la inicialización moderna que encontraste.
        // Esto le dice a Firebase que use el backend de "Google AI" (el de desarrollador).
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        
        // Creamos el modelo a partir de ese servicio
        self.generativeModel = ai.generativeModel(modelName: "gemini-2.5-flash-lite")
        
        startNewChat()
    }

    func startNewChat() {
        conversation.removeAll()
        isLoading = false
        conversation.append(
            Message(role: .chatAI,
                    message: "👋 Hola, soy GuIA. ¿En qué puedo ayudarte hoy?")
        )
    }

    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }

        isLoading = true
        let userMessage = Message(role: .user, message: text)
        conversation.append(userMessage)

        Task {
            do {
                let systemPrompt = """
                Eres 'Axolote', un asistente virtual experto y amigable enfocado en tres áreas clave para un usuario en México:
                1. Turismo: Proporciona recomendaciones detalladas.
                2. Comercio local: Recomienda negocios locales y mercados.
                3. Seguridad: Ofrece consejos prácticos y claros.
                Responde siempre en español.
                """
                
                let response = try await generativeModel.generateContent(systemPrompt, text)
                isLoading = false

                if let reply = response.text {
                    let botMessage = Message(role: .chatAI, message: reply)
                    conversation.append(botMessage)
                }

            } catch {
                isLoading = false
                addErrorMessage("Error al conectar con Gemini: \(error.localizedDescription)")
                print("❌ Error de Firebase/Gemini: \(error)")
            }
        }
    }

    private func addErrorMessage(_ detail: String) {
        conversation.append(Message(role: .chatAI, message: detail))
    }
}
