//
//  MapView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI
import MapKit

struct MapView: View
{
    var body: some View
    {
        ZStack {
            Color("ColorFondos").ignoresSafeArea()
            Text("pantalla mapa")
        }
    }
}

#Preview {
    MapView()
}
