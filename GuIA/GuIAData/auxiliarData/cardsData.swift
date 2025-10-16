//
//  dataForCards.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 11/10/25.
//

/*agregue este objeto para solucionar le problema con el problema de las cartas, sin embargo no estaria demas completarlo con cartas
 rechazadas y todas las cartas ademas de poner SwipeCardModel en una vista por aparte
*/
import Foundation
import SwiftUI

class cardsData: ObservableObject {
    @Published var aceptadas: [SwipeCardModel] = []
    @Published var rechazadas: [SwipeCardModel] = []
    @Published var recomendaciones: [SwipeCardModel] = [
        SwipeCardModel(imageName: "frida", descripcion: "Me encanta el aire libre, vivir y disfrutar la naturaleza."),
        SwipeCardModel(imageName: "carlos", descripcion: "Amante del café y los libros, buscando nuevas aventuras."),
        SwipeCardModel(imageName: "luna", descripcion: "Fan de los museos, el cine y los paseos nocturnos.")
    ]
    
    // Lista default para toDoView
    @Published var defaultList: [SwipeCardModel] = [
        SwipeCardModel(imageName: "default1", descripcion: "Actividad predeterminada 1"),
        SwipeCardModel(imageName: "default2", descripcion: "Actividad predeterminada 2")
    ]
    
}

