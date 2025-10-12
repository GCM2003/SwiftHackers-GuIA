//
//  recommendationsView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 08/10/25.
//

import SwiftUI
import Foundation

struct SwipeCardModel: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let descripcion: String
}

struct recommendationsView: View {
    // Tarjetas iniciales
    let todasLasTarjetas: [SwipeCardModel] = [
        SwipeCardModel(imageName: "frida", descripcion: "Me encanta el aire libre, vivir y disfrutar la naturaleza."),
        SwipeCardModel(imageName: "carlos", descripcion: "Amante del café y los libros, buscando nuevas aventuras."),
        SwipeCardModel(imageName: "luna", descripcion: "Fan de los museos, el cine y los paseos nocturnos.")
    ]
    
    @State private var tarjetas: [SwipeCardModel] = []
    @EnvironmentObject var cards: cardsData
    @State private var rechazadas: [SwipeCardModel] = []
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color("ColorFondos").ignoresSafeArea()
                
                if tarjetas.isEmpty {
                    VStack(spacing: 20) {
                        Text("Esas fueron todas las recomendaciones por el momento...")
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(Color("HomeButtons"))
                        
                        NavigationLink(destination: toDoView(aceptadas:$cards.aceptadas)) {
                            Text("Ver aceptados")
                                .padding()
                                .background(Color("HomeButtons"))
                                .foregroundColor(Color("ColorFondos"))
                                .cornerRadius(12)
                        }
                    }
                } else {
                    ForEach(tarjetas.indices.reversed(), id: \.self) { index in
                        SwipeableCard(tarjeta: tarjetas[index]) {
                            cards.aceptadas.append(tarjetas[index])
                            tarjetas.remove(at: index)
                        } onReject: {
                            rechazadas.append(tarjetas[index])
                            tarjetas.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    private func recargarTarjetas() {
        // Filtra las que no estén en aceptadas ni rechazadas
        let usadas = Set(cards.aceptadas + rechazadas)
        let nuevas = todasLasTarjetas.filter { !usadas.contains($0) }
        
        if nuevas.isEmpty {
            // Si ya no hay nuevas, vuelve a mostrar el mensaje
            tarjetas = []
        } else {
            tarjetas = nuevas
        }
    }
}

struct SwipeableCard: View {
    let tarjeta: SwipeCardModel
    var onAccept: () -> Void
    var onReject: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        VStack {
            Image(tarjeta.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400)
                .clipped()
                .cornerRadius(20)
            
            Text(tarjeta.descripcion)
                .padding()
                .frame(width: 300)
                .background(Color("HomeButtons"))
                .foregroundColor(Color("ColorFondos"))
                .cornerRadius(10)
        }
        .background(
            ZStack {
                if offset.width > 0 {
                    Color.green.opacity(Double(min(offset.width / 150, 1)))
                } else if offset.width < 0 {
                    Color.red.opacity(Double(min(-offset.width / 150, 1)))
                } else {
                    Color.white
                }
            }
        )
        .cornerRadius(20)
        .shadow(radius: 5)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if offset.width > 100 {
                        onAccept()
                    } else if offset.width < -100 {
                        onReject()
                    }
                    offset = .zero
                }
        )
        .animation(.spring(), value: offset)
    }
}

#Preview {
    recommendationsView()
}
