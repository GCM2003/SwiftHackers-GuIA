//
//  MapView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var showSecurityZones = false
    @State private var activeFilter: LocationCategory? = nil
    @Binding var selectedLocation: Location?
    
    // ✅ 1. Cambiamos el estado inicial a 'false' para ocultar el transporte al entrar.
    @State private var showTransport = false

    private var filteredLocations: [Location] {
        // ✅ 2. Modificamos la lógica: si no hay filtro activo (es nil), no mostramos nada.
        guard let filter = activeFilter else {
            return [] // Devolvemos un arreglo vacío
        }
        // Si hay un filtro, devolvemos solo los que coincidan.
        return MockData.locations.filter { $0.category == filter }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $locationManager.cameraPosition) {
                // Puntos de Interés (ahora inician ocultos)
                ForEach(filteredLocations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Button { selectedLocation = location } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(pinColor(for: location.category))
                                Text(location.name).font(.caption).padding(5)
                                    .background(.white).clipShape(RoundedRectangle(cornerRadius: 8)).shadow(radius: 3)
                            }
                        }
                    }
                }
                
                // Íconos de Transporte (ahora inician ocultos)
                if showTransport {
                    ForEach(MockData.transportStations) { station in
                        Annotation(station.name, coordinate: station.coordinate) {
                            Button { selectedLocation = station } label: {
                                Image(systemName: "tram.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(pinColor(for: station.category))
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }

                if showSecurityZones {
                    ForEach(MockData.securityZones) { zone in
                        MapCircle(center: zone.coordinate, radius: zone.radius)
                            .foregroundStyle(.red.opacity(0.4)).stroke(.red.opacity(0.8), lineWidth: 2)
                    }
                }
                UserAnnotation()
            }
            .mapControls { MapUserLocationButton(); MapCompass() }
            .ignoresSafeArea()

            // Filtros superiores
            VStack {
                HStack(spacing: 8) {
                    Button { showSecurityZones.toggle() } label: {
                        Label("", systemImage: showSecurityZones ? "shield.fill" : "shield.slash.fill")
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(.ultraThinMaterial).clipShape(Capsule())
                    
                    Button { showTransport.toggle() } label: {
                        Label("", systemImage: showTransport ? "tram" : "tram.fill")
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(.ultraThinMaterial).clipShape(Capsule())
                    
                    Rectangle().frame(width: 1, height: 20).foregroundColor(.gray.opacity(0.5))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            FilterButton(label: "Itinerario", category: .itinerary, activeFilter: $activeFilter)
                            FilterButton(label: "Comida", category: .food, activeFilter: $activeFilter)
                            FilterButton(label: "Interés", category: .interest, activeFilter: $activeFilter)
                        }
                    }
                }
                .padding(8).background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 25)).shadow(radius: 5).padding(.top)
                Spacer()
            }
            
            // Vista de detalles
            if let location = selectedLocation {
                LocationDetailView(location: $selectedLocation)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: selectedLocation)
        .animation(.easeInOut, value: showTransport)
        .alert("Permiso de Ubicación Requerido", isPresented: $locationManager.isPermissionDenied) {
            Button("Ir a Ajustes") {
                if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Para centrar el mapa en tu posición y ofrecerte la mejor experiencia, necesitamos acceso a tu ubicación. Por favor, actívalo en los ajustes de tu dispositivo.")
        }
    }
    
    func pinColor(for category: LocationCategory) -> Color {
        switch category {
        case .itinerary: return .blue
        case .food: return .orange
        case .interest: return .purple
        case .transport: return .green
        }
    }
}
// ✅ PASO 4: Creamos la vista para el modal de detalles.
struct LocationDetailView: View
{
    // Usamos un Binding para poder cerrar la vista desde dentro,
    // asignando nil a la variable de estado de la vista padre.
    @Binding var location: Location?
    
    var body: some View {
        VStack(spacing: 16) {
            // --- Cabecera con Título y Botón de Cerrar ---
            HStack {
                Text(location?.name ?? "Lugar de Interés")
                    .font(.title2).bold()
                Spacer()
                Button {
                    location = nil // Al pulsar, se cierra la vista.
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // --- Contenido de Detalles ---
            VStack(alignment: .leading, spacing: 12) {
                Text(location?.description ?? "")
                    .font(.body)
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text("Costo: \(location?.estimatedCost ?? "No disponible")")
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "map.fill")
                        .foregroundColor(.blue)
                    Text("Ruta: \(location?.proposedRoute ?? "No disponible")")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // --- Botón de Acción Principal ---
            Button {
                // Aquí iría la lógica para trazar la ruta en el mapa.
                // Por ahora, solo cerramos el modal.
                location = nil
            } label: {
                Text("Trazar Ruta")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(.regularMaterial) // Material translúcido
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

// Creamos una vista reutilizable para los botones de filtro.
struct FilterButton: View {
    let label: String
    let category: LocationCategory
    @Binding var activeFilter: LocationCategory?
    
    // Propiedad que nos dice si este botón está seleccionado.
    var isSelected: Bool {
        activeFilter == category
    }
    
    var body: some View {
        Button {
            // Si el botón ya está seleccionado, lo deseleccionamos (ponemos nil).
            if isSelected {
                activeFilter = nil
            } else {
                // Si no, lo seleccionamos.
                activeFilter = category
            }
        } label: {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Capsule())
        }
        .animation(.easeInOut, value: activeFilter)
    }
}

#Preview {
    // Usamos un Group para mostrar múltiples vistas previas
    Group {
        
        // --- Escenario 1: Modal CERRADO ---
        // Le pasamos .constant(nil) para simular que no hay ninguna ubicación seleccionada.
        MapView(selectedLocation: .constant(nil))
            .previewDisplayName("Mapa (Modal Cerrado)")

        // --- Escenario 2: Modal ABIERTO ---
        // Le pasamos una ubicación de prueba para ver cómo se ve el modal.
        MapView(selectedLocation: .constant(MockData.locations.first))
            .previewDisplayName("Mapa (Modal Abierto)")

    }
    // No olvides añadir el environmentObject para que el LocationManager funcione en la preview
    .environmentObject(LocationManager())
}
