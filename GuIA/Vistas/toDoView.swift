//
//  toDoView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI

struct toDoView: View {
    @EnvironmentObject var cards: cardsData
    
    var body: some View {
        NavigationStack {
            VStack {
                // Botón superior
                HStack {
                    Spacer()
                    NavigationLink(destination: recommendationsView()) {
                        Text("Ver más recomendaciones")
                            .bold()
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color("HomeButtons"))
                            .foregroundColor(Color("ColorFondos"))
                            .cornerRadius(12)
                    }
                }
                .padding()
                
                // Lista de aceptados o default
                ScrollView {
                    VStack(spacing: 20) {
                        if cards.aceptadas.isEmpty {
                            ForEach(cards.defaultList) { tarjeta in
                                AceptadoCard(tarjeta: tarjeta)
                            }
                        } else {
                            ForEach(cards.aceptadas + cards.defaultList) { tarjeta in
                                AceptadoCard(tarjeta: tarjeta)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color("ColorFondos").ignoresSafeArea())
            .navigationTitle("Mis aceptados")
        }
    }
}

// 🔹 Tarjeta de aceptado
struct AceptadoCard: View {
    let tarjeta: SwipeCardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(tarjeta.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(15)
            
            Text(tarjeta.descripcion)
                .font(.body)
                .foregroundColor(Color("HomeButtons"))
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


#Preview
{
    toDoView()
}

