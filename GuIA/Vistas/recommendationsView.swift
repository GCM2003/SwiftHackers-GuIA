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
    @EnvironmentObject var cards: cardsData
    
    var body: some View {
        ZStack {
            Color("ColorFondos").ignoresSafeArea()
            
            if cards.recomendaciones.isEmpty {
                VStack(spacing: 20) {
                    Text("Esas fueron todas las recomendaciones por el momento...")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("HomeButtons"))
                    
                    Button("Recargar recomendaciones") {
                        cards.recomendaciones = cards.rechazadas + cards.aceptadas // o lógica de recarga
                        cards.rechazadas.removeAll()
                        cards.aceptadas.removeAll()
                    }
                    .padding()
                    .background(Color("HomeButtons"))
                    .foregroundColor(Color("ColorFondos"))
                    .cornerRadius(12)
                }
            } else {
                ForEach(cards.recomendaciones.indices.reversed(), id: \.self) { index in
                    SwipeableCard(tarjeta: cards.recomendaciones[index]) {
                        cards.aceptadas.append(cards.recomendaciones[index])
                        cards.recomendaciones.remove(at: index)
                    } onReject: {
                        cards.rechazadas.append(cards.recomendaciones[index])
                        cards.recomendaciones.remove(at: index)
                    }
                }
            }
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
