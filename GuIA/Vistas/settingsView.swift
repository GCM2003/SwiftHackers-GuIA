//
//  settingView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//
import SwiftUI

struct settingsView: View {
    @State private var nombre: String = "Juan López Granados"
    @State private var correo: String = "juangranados@gmail.com"
    @State private var numero: String = "55-1234-5678"
    @State private var gustos: String = "Comida mexicana, viajes"
    @State private var hobbies: String = "Fútbol, lectura, videojuegos"
    @State private var sexualidad: String = "Heterosexual"
    
    @State private var modoOscuro: Bool = false
    @State private var compartirInfo: Bool = false
    
    var body: some View {
        ZStack {
            Color("ColorFondos").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Header
                    VStack {
                        Text("Mi perfil")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("HomeButtons"))
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color("ColorBotones"))
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 20)
                    
                    // Información de la cuenta
                    GroupBox(label: Text("Información de la cuenta").bold()) {
                        VStack(alignment: .leading, spacing: 15) {
                            CustomTextField(title: "Nombre", text: $nombre)
                            CustomTextField(title: "Correo", text: $correo)
                            CustomTextField(title: "Número", text: $numero)
                        }
                        .padding()
                    }
                    
                    // Preferencias personales
                    GroupBox(label: Text("Preferencias personales").bold()) {
                        VStack(alignment: .leading, spacing: 15) {
                            CustomTextField(title: "Gustos", text: $gustos)
                            CustomTextField(title: "Hobbies", text: $hobbies)
                            CustomTextField(title: "Sexualidad", text: $sexualidad)
                        }
                        .padding()
                    }
                    
                    // Ajustes
                    GroupBox(label: Text("Ajustes y preferencias").bold()) {
                        VStack(alignment: .leading, spacing: 15) {
                            Toggle("Modo oscuro", isOn: $modoOscuro)
                            Toggle("Compartir nombre y foto", isOn: $compartirInfo)
                        }
                        .padding()
                    }
                    
                    // Botón de guardar
                    Button(action: {
                        // Aquí guardas los datos en tu modelo o base de datos
                        print("Datos guardados")
                    }) {
                        Text("Guardar cambios")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("HomeButtons"))
                            .foregroundColor(Color("ColorFondos"))
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}

// 🔹 Componente reutilizable para campos de texto
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color("HomeButtons"))
            TextField("Escribe tu \(title.lowercased())...", text: $text)
                .padding()
                .background(Color("ColorFondos"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("HomeButtons"), lineWidth: 2)
                )
        }
    }
}

#Preview {
    settingsView()
}
