//
//  LocationData.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 16/10/25.
//

import Foundation
import MapKit

// Enum para las categorías de los lugares
enum LocationCategory {
    case itinerary, interest, food, transport
}

// Modelo de una ubicación
struct Location: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: LocationCategory
    let description: String
    let estimatedCost: String
    let proposedRoute: String

    // Función para cumplir con el protocolo Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

// Modelo para las zonas de seguridad
struct SecurityZone: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance // Radio en metros
}

// Contenedor con los datos de prueba
struct MockData {

    // Datos para los pines en el mapa
    static let locations = [
            // --- Itinerario ---
            Location(name: "Zócalo", coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), category: .itinerary, description: "El corazón de la Ciudad de México...", estimatedCost: "$50 - $150 MXN", proposedRoute: "Toma la Línea 2 del Metro..."),
            Location(name: "Estadio Azteca", coordinate: CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1504), category: .itinerary, description: "Recinto legendario del fútbol mundial...", estimatedCost: "Varía por evento.", proposedRoute: "La mejor opción es el Tren Ligero..."),
            
            // --- Sitios de Interés ---
            Location(name: "Angel de la Independencia", coordinate: CLLocationCoordinate2D(latitude: 19.4270, longitude: -99.1677), category: .interest, description: "Monumento icónico en Paseo de la Reforma...", estimatedCost: "Gratis", proposedRoute: "Usa el Metrobús Línea 7..."),
            Location(name: "Palacio de Bellas Artes", coordinate: CLLocationCoordinate2D(latitude: 19.4352, longitude: -99.1412), category: .interest, description: "Impresionante edificio de mármol...", estimatedCost: "$85 MXN (Entrada)", proposedRoute: "Metro, estación Bellas Artes..."),
            
            // --- 📍 NUEVOS LUGARES DE INTERÉS ---
            Location(name: "Castillo de Chapultepec",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4204, longitude: -99.1818),
                     category: .interest,
                     description: "Un castillo real en la cima de una colina con vistas espectaculares. Alberga el Museo Nacional de Historia.",
                     estimatedCost: "$95 MXN (Entrada)",
                     proposedRoute: "Camina a través del Bosque de Chapultepec desde Metro Chapultepec."),
            Location(name: "Museo Frida Kahlo (Casa Azul)",
                     coordinate: CLLocationCoordinate2D(latitude: 19.3551, longitude: -99.1623),
                     category: .interest,
                     description: "El hogar donde nació y murió la icónica artista Frida Kahlo, preservado como museo.",
                     estimatedCost: "$250 - $270 MXN (Compra boletos en línea con anticipación).",
                     proposedRoute: "Metro Coyoacán y después una caminata o un taxi corto."),
            Location(name: "Museo Soumaya",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4408, longitude: -99.2043),
                     category: .interest,
                     description: "Edificio de arquitectura vanguardista con una vasta colección de arte europeo y mexicano.",
                     estimatedCost: "Entrada Gratuita.",
                     proposedRoute: "Ubicado en Plaza Carso, Polanco. Mejor acceso en taxi o Uber."),
            Location(name: "Xochimilco",
                     coordinate: CLLocationCoordinate2D(latitude: 19.2880, longitude: -99.1020),
                     category: .interest,
                     description: "Navega por antiguos canales en coloridas trajineras. Una experiencia festiva y tradicional.",
                     estimatedCost: "~$600 MXN por hora por trajinera.",
                     proposedRoute: "Toma el Tren Ligero desde Metro Tasqueña hasta la terminal Xochimilco."),
            Location(name: "Templo Mayor",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4347, longitude: -99.1313),
                     category: .interest,
                     description: "Las ruinas del centro ceremonial de la antigua capital azteca, Tenochtitlan, junto al Zócalo.",
                     estimatedCost: "$95 MXN (Entrada)",
                     proposedRoute: "A un costado de la Catedral, en Metro Zócalo."),
            Location(name: "Monumento a la Revolución",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4361, longitude: -99.1549),
                     category: .interest,
                     description: "Mausoleo y mirador con una de las mejores vistas panorámicas del centro de la ciudad.",
                     estimatedCost: "$120 MXN (Elevador)",
                     proposedRoute: "Cercano a Metro Revolución (Línea 2)."),

            // --- Comida ---
            Location(name: "Tacos 'El Califa'", coordinate: CLLocationCoordinate2D(latitude: 19.4150, longitude: -99.1750), category: .food, description: "Una de las taquerías más famosas...", estimatedCost: "$250 - $400 MXN p/p", proposedRoute: "Ideal para llegar en Uber/Didi..."),
            Location(name: "Churrería El Moro", coordinate: CLLocationCoordinate2D(latitude: 19.4330, longitude: -99.1415), category: .food, description: "Churros y chocolate caliente desde 1935...", estimatedCost: "$100 - $200 MXN p/p", proposedRoute: "A unos pasos de Bellas Artes..."),
            
            // --- 🌮 NUEVOS LUGARES DE COMIDA ---
            Location(name: "Café de Tacuba",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4361, longitude: -99.1381),
                     category: .food,
                     description: "Restaurante histórico con más de 100 años de tradición, famoso por su arquitectura y comida mexicana clásica.",
                     estimatedCost: "$400 - $700 MXN por persona.",
                     proposedRoute: "A unas calles de Bellas Artes, en Metro Allende."),
            Location(name: "Contramar",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4190, longitude: -99.1690),
                     category: .food,
                     description: "El lugar por excelencia para mariscos a la hora de la comida en la colonia Roma. Famoso por sus tostadas de atún.",
                     estimatedCost: "$800 - $1,500 MXN por persona.",
                     proposedRoute: "Reserva con semanas de anticipación. Mejor llegar en taxi/Uber."),
            Location(name: "Tacos de Canasta 'Los Especiales'",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4335, longitude: -99.1360),
                     category: .food,
                     description: "Una experiencia legendaria y económica en el Centro Histórico para probar los auténticos tacos de canasta.",
                     estimatedCost: "$10 - $50 MXN por persona.",
                     proposedRoute: "Ubicado en una calle peatonal, muy cerca del Zócalo."),
            Location(name: "Mercado de Coyoacán",
                     coordinate: CLLocationCoordinate2D(latitude: 19.3500, longitude: -99.1630),
                     category: .food,
                     description: "Famoso por sus puestos de tostadas, quesadillas y antojitos. Un lugar vibrante para comer.",
                     estimatedCost: "$100 - $250 MXN por persona.",
                     proposedRoute: "Disfruta el ambiente del centro de Coyoacán."),
            Location(name: "Pastelería Ideal",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4320, longitude: -99.1390),
                     category: .food,
                     description: "Una pastelería gigantesca y tradicional en el Centro, famosa por su inmensa variedad de pan y pasteles.",
                     estimatedCost: "$50 - $200 MXN.",
                     proposedRoute: "Cerca de Metro San Juan de Letrán."),
            Location(name: "Mercado de San Juan",
                     coordinate: CLLocationCoordinate2D(latitude: 19.4290, longitude: -99.1450),
                     category: .food,
                     description: "El mercado gourmet y exótico de la ciudad. Encuentra desde tapas españolas hasta carne de león o cocodrilo.",
                     estimatedCost: "Variable. Puedes comer tapas por $200 o comprar ingredientes exóticos.",
                     proposedRoute: "Metro Salto del Agua es la estación más cercana.")
        ]

    // ✅ Zonas de Seguridad con las nuevas ubicaciones.
    // NOTA: Estas son zonas de ejemplo y no representan datos de seguridad reales y precisos.
    static let securityZones = [
        // --- CDMX ---
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.4323, longitude: -99.1332), radius: 2500), // Cuauhtémoc (Centro)
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.3580, longitude: -99.0620), radius: 5000), // Iztapalapa
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.5040, longitude: -99.1150), radius: 4500), // Gustavo A. Madero
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.4320, longitude: -99.0880), radius: 3000), // Venustiano Carranza
        
        // --- Alrededores de CDMX (Estado de México) ---
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.2625, longitude: -98.8800), radius: 4000), // Chalco
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.4130, longitude: -98.9550), radius: 3500), // Chimalhuacán
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.5360, longitude: -99.0200), radius: 5000), // Ecatepec
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.6640, longitude: -99.2150), radius: 4000), // Cuautitlán Izcalli
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.4600, longitude: -99.2800), radius: 4500), // Naucalpan
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.2925, longitude: -99.6560), radius: 5000), // Toluca
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 19.5370, longitude: -99.2000), radius: 4000), // Tlalnepantla
        
        // --- Guadalajara ---
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 20.6930, longitude: -103.3400), radius: 800),  // Pueblo Quieto
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 20.6680, longitude: -103.3400), radius: 1000), // Barrio de Analco
        
        // --- Monterrey ---
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 25.6810, longitude: -100.3180), radius: 1200), // Avenida Villagrán (Centro)
        SecurityZone(coordinate: CLLocationCoordinate2D(latitude: 25.6560, longitude: -100.3150), radius: 2000)  // Colonia Independencia
    ]
    
    static let transportStations = [
            // --- 🚇 METRO (35 Estaciones Clave) ---
            // Línea 1 (Rosa)
            Location(name: "Metro Observatorio", coordinate: .init(latitude: 19.398, longitude: -99.201), category: .transport, description: "Terminal Poniente y conexión con la Terminal de Autobuses.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta de Movilidad Integrada (MI)."),
            Location(name: "Metro Chapultepec", coordinate: .init(latitude: 19.420, longitude: -99.177), category: .transport, description: "Entrada principal al Bosque de Chapultepec y museos.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Insurgentes", coordinate: .init(latitude: 19.425, longitude: -99.167), category: .transport, description: "Corazón de la Zona Rosa y conexión con Metrobús Línea 1.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Pino Suárez", coordinate: .init(latitude: 19.424, longitude: -99.132), category: .transport, description: "Conexión con Línea 2 y cercanía al Mercado de San Juan.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro San Lázaro", coordinate: .init(latitude: 19.431, longitude: -99.113), category: .transport, description: "Conexión con la Terminal de Autobuses de Pasajeros de Oriente (TAPO).", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Pantitlán", coordinate: .init(latitude: 19.415, longitude: -99.072), category: .transport, description: "La terminal más grande de la red, conecta 4 líneas.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            
            // Línea 2 (Azul)
            Location(name: "Metro Cuatro Caminos", coordinate: .init(latitude: 19.460, longitude: -99.217), category: .transport, description: "Terminal Norte, ubicada en el Estado de México.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Hidalgo", coordinate: .init(latitude: 19.437, longitude: -99.145), category: .transport, description: "Junto a la Alameda Central y Bellas Artes.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Zócalo/Tenochtitlan", coordinate: .init(latitude: 19.432, longitude: -99.131), category: .transport, description: "Acceso directo a la Plaza de la Constitución.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Chabacano", coordinate: .init(latitude: 19.405, longitude: -99.140), category: .transport, description: "Importante conexión de las líneas 2, 8 y 9.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Tasqueña", coordinate: .init(latitude: 19.345, longitude: -99.142), category: .transport, description: "Terminal Sur, conexión con Tren Ligero y Terminal de Autobuses del Sur.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),

            // Línea 3 (Verde Olivo)
            Location(name: "Metro Indios Verdes", coordinate: .init(latitude: 19.501, longitude: -99.117), category: .transport, description: "Terminal Norte, conexión con Metrobús y Cablebús.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro La Raza", coordinate: .init(latitude: 19.471, longitude: -99.140), category: .transport, description: "Famosa por su 'Túnel de la Ciencia'.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Guerrero", coordinate: .init(latitude: 19.444, longitude: -99.146), category: .transport, description: "Conexión con la Línea B.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Balderas", coordinate: .init(latitude: 19.428, longitude: -99.151), category: .transport, description: "Cercana a la Ciudadela y el mercado de artesanías.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Centro Médico", coordinate: .init(latitude: 19.407, longitude: -99.157), category: .transport, description: "Conexión con Línea 9 y acceso al complejo hospitalario.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Zapata", coordinate: .init(latitude: 19.373, longitude: -99.165), category: .transport, description: "Conexión con la Línea 12 (Dorada).", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Coyoacán", coordinate: .init(latitude: 19.351, longitude: -99.171), category: .transport, description: "Acceso a la zona comercial de Coyoacán.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Universidad", coordinate: .init(latitude: 19.324, longitude: -99.185), category: .transport, description: "Terminal Sur, acceso principal a Ciudad Universitaria (UNAM).", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),

            // Línea 7 (Naranja)
            Location(name: "Metro El Rosario", coordinate: .init(latitude: 19.507, longitude: -99.207), category: .transport, description: "Terminal Norponiente, conexión con Línea 6.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Auditorio", coordinate: .init(latitude: 19.424, longitude: -99.195), category: .transport, description: "Acceso al Auditorio Nacional y zona hotelera de Polanco.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Polanco", coordinate: .init(latitude: 19.432, longitude: -99.192), category: .transport, description: "Corazón de la zona comercial y de oficinas de Polanco.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Tacubaya", coordinate: .init(latitude: 19.403, longitude: -99.187), category: .transport, description: "Importante conexión de las líneas 1, 7 y 9.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Mixcoac", coordinate: .init(latitude: 19.380, longitude: -99.184), category: .transport, description: "Conexión con la Línea 12.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            
            // Línea 12 (Dorada)
            Location(name: "Metro Mixcoac (L12)", coordinate: .init(latitude: 19.380, longitude: -99.185), category: .transport, description: "Terminal Poniente de la Línea Dorada.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Ermita", coordinate: .init(latitude: 19.362, longitude: -99.145), category: .transport, description: "Conexión con la Línea 2.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Atlalilco", coordinate: .init(latitude: 19.352, longitude: -99.112), category: .transport, description: "Conexión con la Línea 8 en Iztapalapa.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Tláhuac", coordinate: .init(latitude: 19.288, longitude: -99.006), category: .transport, description: "Terminal Suroriente de la Línea 12.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),

            // Línea B (Verde/Gris)
            Location(name: "Metro Buenavista", coordinate: .init(latitude: 19.447, longitude: -99.153), category: .transport, description: "Terminal Poniente, conexión con Metrobús y Tren Suburbano.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Garibaldi/Lagunilla", coordinate: .init(latitude: 19.443, longitude: -99.139), category: .transport, description: "Acceso a la Plaza Garibaldi (Mariachis) y el mercado de Lagunilla.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Oceanía", coordinate: .init(latitude: 19.439, longitude: -99.083), category: .transport, description: "Conexión con Línea 5, cercana al Aeropuerto.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Múzquiz", coordinate: .init(latitude: 19.508, longitude: -99.030), category: .transport, description: "Estación en el municipio de Ecatepec.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Ciudad Azteca", coordinate: .init(latitude: 19.522, longitude: -99.015), category: .transport, description: "Terminal Oriente en Ecatepec, conexión con Mexibús.", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),
            Location(name: "Metro Villa de Aragón", coordinate: .init(latitude: 19.46, longitude: -99.05), category: .transport, description: "Estación de la Línea B en la Gustavo A. Madero", estimatedCost: "$5.00 MXN", proposedRoute: "Acceso con Tarjeta MI."),

            // --- 🚍 METROBÚS (35 Paradas Clave) ---
            // Línea 1 (Roja - Insurgentes)
            Location(name: "MB Indios Verdes", coordinate: .init(latitude: 19.501, longitude: -99.118), category: .transport, description: "Terminal Norte, conexión con Metro y Cablebús.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Buenavista", coordinate: .init(latitude: 19.447, longitude: -99.152), category: .transport, description: "Conexión con Metro, Tren Suburbano y otras líneas de MB.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Reforma", coordinate: .init(latitude: 19.432, longitude: -99.159), category: .transport, description: "Parada clave en el corredor turístico de Reforma.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Insurgentes", coordinate: .init(latitude: 19.425, longitude: -99.166), category: .transport, description: "Glorieta de Insurgentes, conexión con Metro Línea 1.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Chilpancingo", coordinate: .init(latitude: 19.407, longitude: -99.171), category: .transport, description: "Corazón de la colonia Condesa.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB World Trade Center", coordinate: .init(latitude: 19.393, longitude: -99.174), category: .transport, description: "Acceso al WTC y Pepsi Center.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Félix Cuevas", coordinate: .init(latitude: 19.362, longitude: -99.175), category: .transport, description: "Conexión con Línea 12 del Metro.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Doctor Gálvez", coordinate: .init(latitude: 19.333, longitude: -99.186), category: .transport, description: "Cercana a Ciudad Universitaria y San Ángel.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB El Caminero", coordinate: .init(latitude: 19.287, longitude: -99.195), category: .transport, description: "Terminal Sur, en la salida a Cuernavaca.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // Línea 2 (Morada - Eje 4 Sur)
            Location(name: "MB Tepalcates", coordinate: .init(latitude: 19.400, longitude: -99.055), category: .transport, description: "Terminal Oriente, conexión con Metro Línea A.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Etiopía", coordinate: .init(latitude: 19.395, longitude: -99.158), category: .transport, description: "Conexión con Metro Línea 3.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Tacubaya", coordinate: .init(latitude: 19.403, longitude: -99.186), category: .transport, description: "Terminal Poniente, conexión con 3 líneas de Metro.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // Línea 3 (Verde)
            Location(name: "MB Tenayuca", coordinate: .init(latitude: 19.525, longitude: -99.162), category: .transport, description: "Terminal Norte en Tlalnepantla.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Balderas (L3)", coordinate: .init(latitude: 19.428, longitude: -99.150), category: .transport, description: "Conexión con Metro Líneas 1 y 3.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Etiopía (L3)", coordinate: .init(latitude: 19.396, longitude: -99.158), category: .transport, description: "Conexión con Metro Línea 3 y MB Línea 2.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // Línea 4 (Naranja - Ruta Sur y Norte/Aeropuerto)
            Location(name: "MB Buenavista (L4)", coordinate: .init(latitude: 19.448, longitude: -99.153), category: .transport, description: "Terminal de la Ruta Sur.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Bellas Artes (L4)", coordinate: .init(latitude: 19.436, longitude: -99.142), category: .transport, description: "Parada clave frente al Palacio de Bellas Artes.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Aeropuerto T1", coordinate: .init(latitude: 19.436, longitude: -99.088), category: .transport, description: "Acceso directo a la Terminal 1 del AICM.", estimatedCost: "$30.00 MXN (Tarifa Especial)", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Aeropuerto T2", coordinate: .init(latitude: 19.414, longitude: -99.080), category: .transport, description: "Acceso directo a la Terminal 2 del AICM.", estimatedCost: "$30.00 MXN (Tarifa Especial)", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB San Lázaro (L4)", coordinate: .init(latitude: 19.431, longitude: -99.114), category: .transport, description: "Conexión con la TAPO y Metro.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // Línea 5 (Azul)
            Location(name: "MB Río de los Remedios", coordinate: .init(latitude: 19.508, longitude: -99.055), category: .transport, description: "Terminal Norte en el límite con Ecatepec.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB San Lázaro (L5)", coordinate: .init(latitude: 19.430, longitude: -99.114), category: .transport, description: "Parada de la Línea 5 en la TAPO.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Preparatoria 1", coordinate: .init(latitude: 19.316, longitude: -99.141), category: .transport, description: "Terminal Sur en la zona de La Noria.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // Línea 6 (Rosa Mexicano)
            Location(name: "MB Villa de Aragón", coordinate: .init(latitude: 19.458, longitude: -99.058), category: .transport, description: "Terminal Oriente, conexión con Metro Línea B.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Deportivo 18 de Marzo", coordinate: .init(latitude: 19.489, longitude: -99.124), category: .transport, description: "Conexión con Metro Líneas 3 y 6.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB El Rosario", coordinate: .init(latitude: 19.507, longitude: -99.206), category: .transport, description: "Terminal Poniente, conexión con Metro Líneas 6 y 7.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            
            // Línea 7 (Verde - Reforma)
            Location(name: "MB Campo Marte", coordinate: .init(latitude: 19.425, longitude: -99.200), category: .transport, description: "Terminal Poniente, junto al Auditorio Nacional.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Auditorio (L7)", coordinate: .init(latitude: 19.424, longitude: -99.196), category: .transport, description: "Parada clave para el Auditorio y Campo Marte.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Ángel", coordinate: .init(latitude: 19.427, longitude: -99.168), category: .transport, description: "Parada en el Ángel de la Independencia.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Hidalgo (L7)", coordinate: .init(latitude: 19.437, longitude: -99.146), category: .transport, description: "Conexión con Metro y otras líneas de MB.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Garibaldi (L7)", coordinate: .init(latitude: 19.443, longitude: -99.140), category: .transport, description: "Acceso a la Plaza Garibaldi.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Hospital Infantil La Villa", coordinate: .init(latitude: 19.484, longitude: -99.117), category: .transport, description: "Terminal Norte, cercana a la Basílica de Guadalupe.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB La Villa", coordinate: .init(latitude: 19.48, longitude: -99.11), category: .transport, description: "Parada de la línea 7 del metrobús en la Basílica", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),
            Location(name: "MB Indios Verdes (L7)", coordinate: .init(latitude: 19.49, longitude: -99.11), category: .transport, description: "Terminal Norte de la Línea 7.", estimatedCost: "$6.00 MXN", proposedRoute: "Uso exclusivo de Tarjeta MI."),

            // --- 🚠 CABLEBÚS (6 Estaciones) ---
            // Línea 1 (Verde)
            Location(name: "Cablebús Indios Verdes", coordinate: .init(latitude: 19.502, longitude: -99.118), category: .transport, description: "Terminal y conexión con Metro y Metrobús.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Cablebús La Pastora", coordinate: .init(latitude: 19.516, longitude: -99.127), category: .transport, description: "Estación intermedia en la zona de Cuautepec.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Cablebús Cuautepec", coordinate: .init(latitude: 19.544, longitude: -99.138), category: .transport, description: "Terminal en el corazón de Cuautepec Barrio Alto.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            
            // Línea 2 (Morada)
            Location(name: "Cablebús Constitución de 1917", coordinate: .init(latitude: 19.340, longitude: -99.065), category: .transport, description: "Terminal y conexión con Metro Línea 8.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Cablebús Quetzalcóatl", coordinate: .init(latitude: 19.332, longitude: -99.045), category: .transport, description: "Estación intermedia en la Sierra de Santa Catarina.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Cablebús Santa Marta", coordinate: .init(latitude: 19.371, longitude: -99.018), category: .transport, description: "Terminal y conexión con Metro Línea A.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),

            // --- 🚎 TROLEBÚS (25 Paradas Representativas) ---
            // Línea 1 (Corredor Cero Emisiones - Eje Central)
            Location(name: "Trolebús Terminal Autobuses del Norte", coordinate: .init(latitude: 19.477, longitude: -99.141), category: .transport, description: "Inicio de ruta en la Terminal del Norte.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Bellas Artes (Eje Central)", coordinate: .init(latitude: 19.435, longitude: -99.142), category: .transport, description: "Parada clave en el Centro Histórico.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Salto del Agua (Eje Central)", coordinate: .init(latitude: 19.426, longitude: -99.143), category: .transport, description: "Conexión con Metro Líneas 1 y 8.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Lázaro Cárdenas (Eje Central)", coordinate: .init(latitude: 19.408, longitude: -99.145), category: .transport, description: "Parada en la colonia Doctores.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Terminal Autobuses del Sur", coordinate: .init(latitude: 19.345, longitude: -99.140), category: .transport, description: "Fin de ruta en la Terminal del Sur (Tasqueña).", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),

            // Línea 2 (Corredor Cero Emisiones - Eje 2 y 2A Sur)
            Location(name: "Trolebús Chapultepec (L2)", coordinate: .init(latitude: 19.421, longitude: -99.176), category: .transport, description: "Inicio de ruta en Metro Chapultepec.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Monterrey (L2)", coordinate: .init(latitude: 19.416, longitude: -99.163), category: .transport, description: "Parada en la colonia Roma.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Velódromo", coordinate: .init(latitude: 19.409, longitude: -99.102), category: .transport, description: "Fin de ruta en la zona del Velódromo Olímpico.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),

            // Línea 3 (Corredor Cero Emisiones - Eje 7 y 7A Sur)
            Location(name: "Trolebús Mixcoac (L3)", coordinate: .init(latitude: 19.380, longitude: -99.183), category: .transport, description: "Parada cerca del Metro Mixcoac.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Félix Cuevas (L3)", coordinate: .init(latitude: 19.362, longitude: -99.174), category: .transport, description: "Parada sobre Eje 7 Sur.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),

            // Línea 5 (San Felipe - Metro Hidalgo)
            Location(name: "Trolebús Metro Hidalgo (L5)", coordinate: .init(latitude: 19.437, longitude: -99.147), category: .transport, description: "Inicio de ruta hacia el norte de la ciudad.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús San Felipe de Jesús", coordinate: .init(latitude: 19.495, longitude: -99.080), category: .transport, description: "Terminal en la Gustavo A. Madero.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            
            // Línea 6 (El Rosario - Chapultepec)
            Location(name: "Trolebús El Rosario (L6)", coordinate: .init(latitude: 19.508, longitude: -99.206), category: .transport, description: "Inicio de ruta en Metro El Rosario.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Mariano Escobedo", coordinate: .init(latitude: 19.438, longitude: -99.185), category: .transport, description: "Parada en la zona de Anzures/Polanco.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),

            // Línea 8 (Circuito Politécnico)
            Location(name: "Trolebús Metro Politécnico", coordinate: .init(latitude: 19.505, longitude: -99.148), category: .transport, description: "Ruta interna que da servicio al IPN Zacatenco.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            
            // Línea 9 (Villa de Cortés - Iztacalco)
            Location(name: "Trolebús Metro Villa de Cortés", coordinate: .init(latitude: 19.388, longitude: -99.144), category: .transport, description: "Inicio de ruta en Calzada de Tlalpan.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Iztacalco", coordinate: .init(latitude: 19.390, longitude: -99.110), category: .transport, description: "Terminal en la alcaldía Iztacalco.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),

            // Línea 10 (Trolebús Elevado)
            Location(name: "Trolebús Constitución de 1917 (Elevado)", coordinate: .init(latitude: 19.341, longitude: -99.064), category: .transport, description: "Inicio de ruta en el viaducto elevado de Iztapalapa.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Trolebús UACM Casa Libertad", coordinate: .init(latitude: 19.310, longitude: -99.030), category: .transport, description: "Terminal oriente del Trolebús Elevado.", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            Location(name: "Trolebús Deportivo Santa Cruz", coordinate: .init(latitude: 19.32, longitude: -99.04), category: .transport, description: "Estación del Trolebús Elevado en Iztapalapa", estimatedCost: "$7.00 MXN", proposedRoute: "Acceso exclusivo con Tarjeta MI."),
            
            // Línea 11 (Santa Marta - Chalco) - PROYECTO
            Location(name: "Trolebús Santa Marta (Chalco)", coordinate: .init(latitude: 19.37, longitude: -99.02), category: .transport, description: "Futura terminal de la línea hacia Chalco.", estimatedCost: "Tarifa por definir", proposedRoute: "En construcción."),
            
            // Línea 12 (Tasqueña - Perisur)
            Location(name: "Trolebús Tasqueña (Perisur)", coordinate: .init(latitude: 19.34, longitude: -99.14), category: .transport, description: "Conexión en la terminal de Tasqueña hacia el sur.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Perisur", coordinate: .init(latitude: 19.30, longitude: -99.20), category: .transport, description: "Parada en el centro comercial Perisur.", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Ciudad Universitaria (CU)", coordinate: .init(latitude: 19.33, longitude: -99.18), category: .transport, description: "Parada para acceder a Ciudad Universitaria", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo."),
            Location(name: "Trolebús Estadio Azteca (Trolebús)", coordinate: .init(latitude: 19.30, longitude: -99.15), category: .transport, description: "Parada del Trolebús en el Estadio Azteca", estimatedCost: "$4.00 MXN", proposedRoute: "Pago con Tarjeta MI o efectivo.")
        ]
}
