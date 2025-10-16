//
//  ContentView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

/*
 En general esta pantalla funciona para navegación en la app
 por medio de la  tabvar
 */
import SwiftUI

struct ContentView: View
{
    @StateObject var cards = cardsData()
    @State var currentView: navigationEnum = .home
    @State private var selectedLocation: Location? = nil

    var body: some View {
            ZStack(alignment: .bottom) {
                
                // --- CAPA 1: CONTENIDO PRINCIPAL ---
                switch currentView {
                case .home:
                    NavigationStack //pongo el navigaationStack aqui porque se usa en homeView y si lo embebo en el Zstack me daña la vista del  mapa
                    {
                        homeView()
                    }
                case .map:
                    // ✅ PASO 2: Pasamos un "binding" ($) al MapView.
                    // Ahora MapView puede modificar el estado que vive en ContentView.
                    MapView(selectedLocation: $selectedLocation)
                case .chatBot:
                    chatBotView()
                }
                
                // --- CAPA 2: BARRA DE NAVEGACIÓN ---
                // ✅ PASO 3: La barra solo se mostrará si no hay ninguna ubicación seleccionada.
                if selectedLocation == nil {
                    Rectangle()
                        .foregroundColor(Color("ColorBotones"))
                        .frame(width: 350, height: 70)
                        .cornerRadius(15)
                        .overlay(
                            Rectangle()
                                .frame(width: 335, height: 55)
                                .foregroundColor(Color("ColorFondos"))
                                .cornerRadius(10)
                                .overlay(
                                    HStack {
                                        Button(action: { currentView = .map }) {
                                            Image(systemName: "map").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color("ColorBotones")).padding(30)
                                        }
                                        Button(action: { currentView = .home }) {
                                            Image(systemName: "house").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color("ColorBotones")).padding(30)
                                        }
                                        Button(action: { currentView = .chatBot }) {
                                            Image(systemName: "message").resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(Color("ColorBotones")).padding(30)
                                        }
                                    }
                                )
                        )
                        .padding(.bottom, 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity)) // Animación
                }
            }
            .animation(.easeInOut, value: selectedLocation)
            .environmentObject(cards)
        }
}
