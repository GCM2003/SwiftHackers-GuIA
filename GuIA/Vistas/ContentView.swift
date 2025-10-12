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

struct ContentView: View {
    @StateObject var cards = cardsData() //para tema cartas de lo que agrego dani
    @State var currentView:navigationEnum = .home //iniciamos en la pantalla principal
    var body: some View {
        NavigationStack {
            GeometryReader //closure para colocar la barra en la parte inferior de la pantalla
            {
            geometry in // parametro que nos devuelve datos de la pantalla
            ZStack {
                switch currentView //con el switch cambiamos de vista según el valor de currentView
                {
                case .home:
                    homeView()
                        .environmentObject(cards) // compartimos el objeto cards de tipo cardsData con homeView
                case .map: MapView()
                case .chatBot: chatBotView()
                }
                Rectangle() //rectangulo para hacer la barra de navegacion
                    .foregroundColor(Color("ColorBotones")) //color de la barra
                    .frame(width: 350,height: 70) //ancho y alto de la barra
                    .cornerRadius(15) // redondeo
                    .overlay(content: {
                        Rectangle()
                            .frame(width: 335,height: 55)
                            .foregroundColor(Color("ColorFondos"))
                            .cornerRadius(10)
                            .overlay(content: {
                                HStack {
                                    Button(action:{
                                        currentView = .map
                                    },label: {
                                        Image(systemName: "map") .resizable() .scaledToFit() .frame(width: 35,height: 35) .foregroundColor(Color("ColorBotones")) .padding(30)
                                    })
                                    Button(action:{
                                        currentView = .home
                                    },label: {
                                        Image(systemName: "house") .resizable() .scaledToFit() .frame(width: 35,height: 35) .foregroundColor(Color("ColorBotones")) .padding(30)
                                    })
                                    Button(action:{
                                        currentView = .chatBot
                                    },label:{
                                        Image(systemName: "message") .resizable() .scaledToFit() .frame(width: 35,height: 35) .foregroundColor(Color("ColorBotones")) .padding(30)
                                    })
                                }
                            })
                    }).position(x:geometry.size.width/2,y:geometry.size.height-30) //configuramos la posicion de la barra.
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
