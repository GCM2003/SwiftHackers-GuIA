//
//  ContentView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

//en general esta pantalla sirve para navegación
import SwiftUI

struct ContentView: View
{
    @State var currentView:navigationEnum  = .home  //iniciamos en la pantalla principal
    var body: some View
    {
        GeometryReader
        {
            geometry  in
            
            ZStack
            {
                switch currentView
                {
                case .home:
                    homeView()
                case .map:
                    MapView()
                case .chatBot:
                    chatBotView()
                case .toDoList:
                    toDoView()
                }
                
                Rectangle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(Color("ColorBotones"))
                    .frame(width: 350,height: 70)
                    .cornerRadius(15)
                    .overlay(content: {
                        HStack
                        {
                            Button(action:{
                                currentView = .map
                            },label: {
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35,height: 35)
                                    .foregroundColor(Color("ColorBotones"))
                                    .padding(30)
                                    })
                            Button(action:{
                                currentView = .home
                            },label: {
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35,height: 35)
                                    .foregroundColor(Color("ColorBotones"))
                                    .padding(30)
                                    })
                            Button(action:{},label: {
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35,height: 35)
                                    .foregroundColor(Color("ColorBotones"))
                                    .padding(30)
                                    })
                        }
                    })
                    .position(x:geometry.size.width/2,y:geometry.size.height-30)
                    
            }
        }
    }
}

#Preview {
    ContentView()
}
