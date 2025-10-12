//
//  MapView.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 07/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 1. EXTENSIONES DE COLOR Y TIPOS

extension Color {
    static let verdeAgave = Color(hex: "#467468")
    static let terracota = Color(hex: "#CE6D39")
    static let fondoClaro = Color(hex: "#F5F5F5")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - 2. MODELOS DE DATOS

enum MapPinType: Equatable {
    case itinerary, interest, food, social, safeZone, lessSafeZone, mixedZone
}

struct MapItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: MapPinType
    let rating: Double?
    let accessibility: Bool
    let ajoloteTip: String

    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Zone: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: [CLLocationCoordinate2D]
    let type: MapPinType
    var polygon: MKPolygon {
        let points = coordinates.map { $0 }
        return MKPolygon(coordinates: points, count: points.count)
    }
}

// Modelo de Anotación Nativa (MKAnnotation) para enlazar los MapItems
class CustomAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var item: MapItem
    
    init(item: MapItem) {
        self.coordinate = item.coordinate
        self.title = item.name
        self.item = item
    }
}

// MARK: - 3. DATOS DE SIMULACIÓN (CDMX con más POIs y Zonas EXPANDIDAS)

class MapDataStore {
    let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.390, longitude: -99.140), // Centro de la simulación
        span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25) // Mayor zoom out para ver las zonas
    )

    let mapItems: [MapItem] = [
        // ITINERARIO (Verde Agave)
        MapItem(name: "Hotel Condesa (Tu Base)", coordinate: CLLocationCoordinate2D(latitude: 19.4124, longitude: -99.1724), type: .itinerary, rating: nil, accessibility: true, ajoloteTip: "Estás en una zona segura. Utiliza el filtro de 'Alrededor de Mí' para explorar la zona."),
        MapItem(name: "Catedral Metropolitana", coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), type: .itinerary, rating: 4.6, accessibility: true, ajoloteTip: "Siguiente destino del día: visita cultural. Ve caminando desde el Templo Mayor."),
        MapItem(name: "Estadio Azteca (Partido Hoy)", coordinate: CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1504), type: .itinerary, rating: nil, accessibility: true, ajoloteTip: "Punto clave de tu viaje. El Ajolote te recomienda usar Metro para evitar el tráfico intenso."),
        
        // INTERÉS / CULTURAL (Terracota)
        MapItem(name: "Museo Nacional de Antropología", coordinate: CLLocationCoordinate2D(latitude: 19.4210, longitude: -99.1866), type: .interest, rating: 4.8, accessibility: true, ajoloteTip: "Una visita obligada antes de las 4 PM. Es totalmente accesible."),
        MapItem(name: "Palacio de Bellas Artes", coordinate: CLLocationCoordinate2D(latitude: 19.4350, longitude: -99.1414), type: .interest, rating: 4.7, accessibility: true, ajoloteTip: "Asegúrate de ver el mural de Rivera en el segundo piso."),
        MapItem(name: "Puesto de Tacos 'El Vilsito'", coordinate: CLLocationCoordinate2D(latitude: 19.3908, longitude: -99.1691), type: .food, rating: 4.5, accessibility: false, ajoloteTip: "¡El Pastor es legendario aquí! Abre después de las 7 PM. Solo efectivo."),
        MapItem(name: "Parque México (Punto Social)", coordinate: CLLocationCoordinate2D(latitude: 19.4109, longitude: -99.1718), type: .social, rating: 4.7, accessibility: true, ajoloteTip: "Aquí te reunirás con tu grupo para el 'Recorrido de Arte Urbano'."),
        MapItem(name: "Mercado de Artesanías Coyoacán", coordinate: CLLocationCoordinate2D(latitude: 19.3490, longitude: -99.1601), type: .social, rating: 4.3, accessibility: true, ajoloteTip: "Sugerencia social: compra recuerdos únicos y prueba las tostadas de coyoacán."),
    ]
    
    // Simulación de Zonas de Seguridad (5 Polígonos simulando Delegaciones/Colonias)
    
    // 1. Zona Segura Grande (Polanco / Chapultepec / Roma)
    let safeZonePolancoRoma = Zone(name: "Zona Segura - Polanco/Roma", coordinates: [
        CLLocationCoordinate2D(latitude: 19.447, longitude: -99.205),
        CLLocationCoordinate2D(latitude: 19.435, longitude: -99.195),
        CLLocationCoordinate2D(latitude: 19.400, longitude: -99.170),
        CLLocationCoordinate2D(latitude: 19.415, longitude: -99.210),
        CLLocationCoordinate2D(latitude: 19.450, longitude: -99.215)
    ], type: .safeZone)
    
    // 2. Zona de Precaución (Centro Histórico)
    let lessSafeZoneCentro = Zone(name: "Precaución Nocturna - Centro", coordinates: [
        CLLocationCoordinate2D(latitude: 19.44, longitude: -99.15),
        CLLocationCoordinate2D(latitude: 19.43, longitude: -99.12),
        CLLocationCoordinate2D(latitude: 19.415, longitude: -99.115),
        CLLocationCoordinate2D(latitude: 19.425, longitude: -99.145)
    ], type: .lessSafeZone)
    
    // 3. Zona Segura (Coyoacán)
    let safeZoneCoyoacan = Zone(name: "Zona Segura - Coyoacán", coordinates: [
        CLLocationCoordinate2D(latitude: 19.360, longitude: -99.170),
        CLLocationCoordinate2D(latitude: 19.330, longitude: -99.150),
        CLLocationCoordinate2D(latitude: 19.350, longitude: -99.130),
        CLLocationCoordinate2D(latitude: 19.370, longitude: -99.145)
    ], type: .safeZone)
    
    // 4. Zona de Precaución (Iztapalapa - Simulación de área grande)
    let lessSafeZoneIztapalapa = Zone(name: "Precaución Extrema - Iztapalapa", coordinates: [
        CLLocationCoordinate2D(latitude: 19.35, longitude: -99.10),
        CLLocationCoordinate2D(latitude: 19.30, longitude: -99.05),
        CLLocationCoordinate2D(latitude: 19.25, longitude: -99.10),
        CLLocationCoordinate2D(latitude: 19.30, longitude: -99.15)
    ], type: .lessSafeZone)
    
    // 5. Zona Mixta/Media (Benito Juárez)
    let mixedZoneBenitoJuarez = Zone(name: "Seguridad Media - Benito Juárez", coordinates: [
        CLLocationCoordinate2D(latitude: 19.400, longitude: -99.150),
        CLLocationCoordinate2D(latitude: 19.380, longitude: -99.140),
        CLLocationCoordinate2D(latitude: 19.370, longitude: -99.170),
        CLLocationCoordinate2D(latitude: 19.390, longitude: -99.180)
    ], type: .interest) // Usamos .interest como color neutro o medio
    
    var allZones: [Zone] {
        return [safeZonePolancoRoma, lessSafeZoneCentro, safeZoneCoyoacan, lessSafeZoneIztapalapa, mixedZoneBenitoJuarez]
    }
}

// MARK: - 4. MAP OVERLAY (UIViewRepresentable UNIFICADO)

struct UnifiedMapWrapper: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var destinationCoordinate: CLLocationCoordinate2D?
    @Binding var selectedItem: MapItem?
    let filteredMapItems: [MapItem]
    let allZones: [Zone]
    @Binding var showSecurityZones: Bool
    
    private let hotelCoordinate = CLLocationCoordinate2D(latitude: 19.4124, longitude: -99.1724)
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    // Se guarda la última coordenada de destino para evitar recálculos excesivos
    @State private var lastDestinationCoordinate: CLLocationCoordinate2D? = nil
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 1. Manejo de la Región (sincronización con SwiftUI)
        uiView.setRegion(region, animated: true)

        // 2. Manejo de Overlays (Polígonos de Zonas de Seguridad)
        let polygonOverlays = uiView.overlays.filter { $0 is MKPolygon }
        uiView.removeOverlays(polygonOverlays)
        
        if showSecurityZones {
            for zone in allZones {
                uiView.addOverlay(zone.polygon)
            }
        }
        
        // 3. Manejo de Anotaciones (Pines)
        let customAnnotations = uiView.annotations.filter { $0 is CustomAnnotation }
        uiView.removeAnnotations(customAnnotations)

        let newAnnotations = filteredMapItems.map { CustomAnnotation(item: $0) }
        uiView.addAnnotations(newAnnotations)
        
        // 4. Dibuja la Ruta
        if let destCoord = destinationCoordinate {
            if destCoord.latitude != lastDestinationCoordinate?.latitude || destCoord.longitude != lastDestinationCoordinate?.longitude {
                
                let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: hotelCoordinate))
                let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destCoord))
                
                let request = MKDirections.Request()
                request.source = startMapItem
                request.destination = endMapItem
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    guard let route = response?.routes.first else {
                        print("Error al calcular la ruta: \(error?.localizedDescription ?? "Desconocido")")
                        return
                    }
                    
                    // Limpia la ruta anterior y añade la nueva
                    let routeOverlays = uiView.overlays.filter { $0 is MKPolyline }
                    uiView.removeOverlays(routeOverlays)
                    uiView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    // Ajusta la región para ver toda la ruta.
                    uiView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 150, left: 50, bottom: 280, right: 50), animated: true)
                    
                    lastDestinationCoordinate = destCoord
                }
            }
        } else {
            // Si no hay ruta, limpiamos la ruta existente.
            let routeOverlays = uiView.overlays.filter { $0 is MKPolyline }
            uiView.removeOverlays(routeOverlays)
            lastDestinationCoordinate = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UnifiedMapWrapper
        
        init(_ parent: UnifiedMapWrapper) {
            self.parent = parent
        }
        
        // 1. Renderiza los Polígonos (Zonas) y Polilíneas (Rutas)
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(Color.verdeAgave)
                renderer.lineWidth = 5
                return renderer
            }
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                
                // Nota: Usamos la primera coordenada del polígono para buscar la zona
                if let zone = parent.allZones.first(where: {
                    $0.coordinates.first?.latitude == polygon.coordinate.latitude &&
                    $0.coordinates.first?.longitude == polygon.coordinate.longitude
                }) {
                    
                    if zone.type == .safeZone {
                        renderer.fillColor = UIColor(.verdeAgave.opacity(0.15))
                        renderer.strokeColor = UIColor(.verdeAgave)
                        renderer.lineWidth = 2
                    } else if zone.type == .lessSafeZone {
                        renderer.fillColor = UIColor(.terracota.opacity(0.15))
                        renderer.strokeColor = UIColor(.terracota)
                        renderer.lineWidth = 2
                    } else { // Zonas Mixtas o Neutras
                        renderer.fillColor = UIColor(.gray.opacity(0.1))
                        renderer.strokeColor = UIColor(.gray.opacity(0.5))
                        renderer.lineWidth = 1
                    }
                }
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        
        // 2. Renderiza los Pines
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
            
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = customAnnotation
                annotationView?.subviews.forEach { $0.removeFromSuperview() }
            }
            
            let hostingController = UIHostingController(rootView: MapPinView(type: customAnnotation.item.type))
            hostingController.view.backgroundColor = .clear
            hostingController.view.isUserInteractionEnabled = true
            
            let pinSize = CGSize(width: 40, height: 45)
            hostingController.view.frame = CGRect(origin: .zero, size: pinSize)
            
            annotationView?.isUserInteractionEnabled = true
            annotationView?.frame = CGRect(x: 0, y: 0, width: pinSize.width, height: pinSize.height)
            annotationView?.centerOffset = CGPoint(x: 0, y: -pinSize.height / 2)
            
            annotationView?.addSubview(hostingController.view)
            
            return annotationView
        }
        
        // 3. Maneja la selección del Pin para mostrar el Bottom Sheet
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
            
            mapView.deselectAnnotation(customAnnotation, animated: false)
            
            self.parent.selectedItem = customAnnotation.item
        }
        
        // 4. Actualiza la región de SwiftUI cuando el usuario mueve el mapa
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.parent.region.center = mapView.region.center
            self.parent.region.span = mapView.region.span
        }
    }
}

// MARK: - 5. VISTA PRINCIPAL

struct MapView: View {
    @State private var region: MKCoordinateRegion = MapDataStore().initialRegion
    @State private var activeFilter: String = "Itinerario"
    @State private var selectedItem: MapItem? = nil
    @State private var destinationCoordinate: CLLocationCoordinate2D? = nil
    
    // El filtro de zonas de seguridad se basa en el filtro activo
    private var showSecurityZones: Bool {
        activeFilter == "Zonas de Seguridad"
    }
    
    // Lógica de filtrado de pines
    private var filteredItems: [MapItem] {
        let allItems = MapDataStore().mapItems
        switch activeFilter {
        case "Itinerario":
            return allItems.filter { $0.type == .itinerary }
        case "Comida":
            return allItems.filter { $0.type == .food }
        case "Social/Cultura":
            return allItems.filter { $0.type == .social || $0.type == .interest }
        case "Zonas de Seguridad":
            return [] // Solo overlays
        default:
            return allItems
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1. Mapa Nativo (MKMapView)
            UnifiedMapWrapper(
                region: $region,
                destinationCoordinate: $destinationCoordinate,
                selectedItem: $selectedItem,
                filteredMapItems: filteredItems,
                allZones: MapDataStore().allZones,
                showSecurityZones: .constant(showSecurityZones)
            )
            .edgesIgnoringSafeArea(.all)
            
            // 2. Controles Superiores (Filtros)
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(label: "Itinerario", activeFilter: $activeFilter)
                        FilterButton(label: "Comida", activeFilter: $activeFilter)
                        FilterButton(label: "Social/Cultura", activeFilter: $activeFilter)
                        FilterButton(label: "Zonas de Seguridad", activeFilter: $activeFilter)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(Color.white.opacity(0.95))
                .cornerRadius(25)
                .shadow(radius: 5)
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            
            // 3. Overlay Flotante Central (Info de Lugar)
            if selectedItem != nil {
                BottomSheetView(selectedItem: $selectedItem, destinationCoord: $destinationCoordinate)
                    .transition(.opacity)
                    .animation(.spring(), value: selectedItem)
                    .padding(.horizontal, 20)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .offset(y: -100)
            }
            
            // 4. Notificación de Ruta Trazada - MOVIMOS ESTO ARRIBA
            if destinationCoordinate != nil {
                HStack {
                    Image(systemName: "figure.walk.circle.fill").font(.title3)
                    Text("Ruta Trazada")
                        .font(.callout.bold())
                    Text("desde tu Hotel.")
                        .font(.callout)
                    Spacer()
                    Button {
                        // Limpia la ruta
                        destinationCoordinate = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.verdeAgave.opacity(0.95))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .top) // Anclado arriba
                .offset(y: 80) // Desplazado hacia abajo para no chocar con los filtros
            }
        }
    }
}


// MARK: - 6. COMPONENTES AUXILIARES

// Simulación de la visualización del Pin en el mapa
struct MapPinView: View {
    let type: MapPinType
    
    var body: some View {
        VStack(spacing: 0) {
            // Icono del pin
            Image(systemName: pinIconName())
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .background(pinColor())
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.fondoClaro, lineWidth: 2))
            
            // Cola del pin
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .rotationEffect(.degrees(180))
                .foregroundColor(pinColor())
                .offset(y: -5)
        }
    }
    
    func pinColor() -> Color {
        switch type {
        case .itinerary:
            return .verdeAgave
        case .interest, .food, .social:
            return .terracota
        case .safeZone, .lessSafeZone, .mixedZone:
            return .gray
        }
    }
    
    func pinIconName() -> String {
        switch type {
        case .itinerary: return "figure.walk.circle.fill"
        case .interest: return "building.2.fill"
        case .food: return "fork.knife.circle.fill"
        case .social: return "person.3.fill"
        case .safeZone: return "checkmark.shield.fill"
        case .lessSafeZone: return "exclamationmark.triangle.fill"
        case .mixedZone: return "mappin.and.ellipse"
        }
    }
}

// Botón para los Filtros Inteligentes (Agrandado)
struct FilterButton: View {
    let label: String
    @Binding var activeFilter: String
    
    var body: some View {
        Text(label)
            .font(.subheadline.weight(.bold))
            .foregroundColor(label == activeFilter ? .white : .primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(label == activeFilter ? Color.verdeAgave : Color.fondoClaro)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(label == activeFilter ? Color.verdeAgave : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .onTapGesture {
                activeFilter = label
            }
    }
}

// Hoja de Detalles (Overlay Central)
struct BottomSheetView: View {
    @Binding var selectedItem: MapItem?
    @Binding var destinationCoord: CLLocationCoordinate2D?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedItem?.name ?? "Ubicación")
                        .font(.title2.bold())
                        .foregroundColor(.verdeAgave)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text("\(selectedItem?.rating ?? 4.5, specifier: "%.1f") estrellas")
                            .font(.subheadline)
                    }
                }
                Spacer()
                // Botón de cerrar
                Button {
                    selectedItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding([.horizontal, .top])

            Divider().padding(.vertical, 8)
            
            // MARK: Logística simulada
            VStack(alignment: .leading, spacing: 10) {
                Text("Ruta Logística por el Ajolote IA")
                    .font(.headline)
                    .foregroundColor(.terracota)
                
                HStack(alignment: .top) {
                    Image(systemName: "bus.fill").foregroundColor(.verdeAgave)
                    // FAKING: Instrucciones de Transporte Dinámicas
                    Text(transportInstructions(for: selectedItem?.name ?? ""))
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill").foregroundColor(.verdeAgave)
                    Text("Costo estimado del viaje: \(costEstimate(for: selectedItem?.name ?? ""))")
                        .font(.subheadline)
                }
                
                Divider()

                // Ajolote Tip
                Text("💡 Ajolote Tip:")
                    .font(.callout.bold())
                    .padding(.top, 5)
                Text(selectedItem?.ajoloteTip ?? "Consejo logístico generado por la IA.")
                    .font(.callout)
                    .lineLimit(3)
            }
            .padding(.horizontal)
            
            // MARK: Botón de Navegación
            Button {
                destinationCoord = selectedItem?.coordinate
                selectedItem = nil // Cierra la hoja
            } label: {
                Text("Iniciar Navegación (Trazar Ruta)")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.verdeAgave)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 400) // Límitamos el ancho para que se vea bien como overlay central
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    // Funciones de simulación de datos
    func transportInstructions(for name: String) -> String {
        if name.contains("Estadio Azteca") {
            return "Toma Metrobus (Línea 1, El Caminero) desde Insurgentes. Duración: 1h 10m."
        } else if name.contains("Catedral") || name.contains("Bellas Artes") {
            return "Caminando: 15-20 minutos. Si llueve, toma un Ecobici."
        } else if name.contains("Tacos") {
            return "Usa Uber X para la noche. Tiempo de espera: 5 min."
        }
        return "Instrucciones de ruta detalladas generadas por el Ajolote IA."
    }
    
    func costEstimate(for name: String) -> String {
        if name.contains("Estadio Azteca") {
            return "$120 MXN (Metrobus) o $350 MXN (Uber)."
        } else if name.contains("Tacos") {
            return "$180 MXN (Viaje Ida y Vuelta)."
        }
        return "Variable. Consulta la opción de transporte sugerida arriba."
    }
}
