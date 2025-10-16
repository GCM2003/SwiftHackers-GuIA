//
//  homeView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI

struct homeView: View
{
    @EnvironmentObject var cards: cardsData
    var body: some View
    {
        GeometryReader
        {
            geometry in
            ZStack
            {
                Color("ColorFondos").ignoresSafeArea()
                VStack
                {
                    NavigationLink(destination: {toDoView()
                        .environmentObject(cards)}, label: {
                        Rectangle()
                            .foregroundColor(Color("HomeButtons"))
                            .frame(width: 350,height: 150)
                            .cornerRadius(20)
                            .overlay(content: {
                                Rectangle()
                                    .frame(width: 330,height: 130)
                                    .foregroundColor(Color("ColorFondos"))
                                    .cornerRadius(20)
                                    .overlay(content: {
                                        HStack
                                        {
                                            Image(systemName: "list.clipboard").resizable().scaledToFit().frame(width: 90,height: 90).foregroundColor(Color("ColorBotones"))
                                                .padding(.trailing,30)
                                            Text("Itinerario")
                                                .padding(.trailing,70)
                                                .foregroundColor(Color("HomeButtons"))
                                                .bold()
                                                .font(.system(size: 30))
                                        }
                                    })
                            })
                    }).padding(.bottom,30)
                    
                    //el siguiente navigtion link puede ir a una pantalla con recomendaciones locales
                    NavigationLink(destination: {toDoView()
                        .environmentObject(cards)}, label: {
                        Rectangle()
                            .foregroundColor(Color("HomeButtons"))
                            .frame(width: 350,height: 150)
                            .cornerRadius(20)
                            .overlay(content: {
                                Rectangle()
                                    .frame(width: 330,height: 130)
                                    .foregroundColor(Color("ColorFondos"))
                                    .cornerRadius(20)
                                    .overlay(content: {
                                        HStack
                                        {
                                            Image(systemName: "lightbulb.min").resizable().scaledToFit().frame(width: 90,height: 90).foregroundColor(Color("ColorBotones"))
                                                .padding(.trailing,30)
                                            Text("Sitios \n locales")
                                                .padding(.trailing,70)
                                                .foregroundColor(Color("HomeButtons"))
                                                .bold()
                                                .font(.system(size: 30))
                                        }
                                    })
                            })
                    }).padding(.bottom,30)
                    
                    
                    NavigationLink(destination: {
                        recommendationsView()
                            .environmentObject(cards)
                    }, label: {
                        Rectangle()
                            .foregroundColor(Color("HomeButtons"))
                            .frame(width: 350,height: 150)
                            .cornerRadius(20)
                            .overlay(content: {
                                Rectangle()
                                    .frame(width: 330,height: 130)
                                    .foregroundColor(Color("ColorFondos"))
                                    .cornerRadius(20)
                                    .overlay(content: {
                                        HStack
                                        {
                                            Image(systemName: "person.3.sequence").resizable().scaledToFit().frame(width: 90,height: 90).foregroundColor(Color("ColorBotones"))
                                                .padding(.trailing,30)
                                            Text("Social")
                                                .padding(.trailing,70)
                                                .foregroundColor(Color("HomeButtons"))
                                                .bold()
                                                .font(.system(size: 30))
                                        }
                                    })
                            })
                    }).padding(.bottom,10)
                    
                    
                }
                
                NavigationLink(destination: {settingsView()}, label: {
                    Image(systemName:"person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50,height: 50)
                        .foregroundColor(Color("ColorBotones"))
                }).position(x:geometry.size.width-50,y:50)
            }
            
        }
        
    }
}

#Preview {
    homeView()
}
