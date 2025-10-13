//
//  dataForCards.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 11/10/25.
//

import SwiftUI

/*agregue este objeto para solucionar le problema con el problema de las cartas, sin embargo no estaria demas completarlo con cartas
 rechazadas y todas las cartas ademas de poner SwipeCardModel en una vista por aaparte
*/
class cardsData: ObservableObject {
    @Published var aceptadas: [SwipeCardModel] = []
}
