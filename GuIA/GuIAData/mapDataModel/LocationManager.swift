//
//  LocationManager.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 16/10/25.
//

import SwiftUI
import Foundation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var cameraPosition: MapCameraPosition = .region(.userRegion)
    @Published var userLocation: CLLocation?
    
   
    @Published var isPermissionDenied = false

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // No es necesario llamar a requestLocation() aquí,
        // locationManagerDidChangeAuthorization se encargará de todo.
    }
    
    // --- FUNCIÓN MODIFICADA PARA PRODUCCIÓN ---
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // El permiso fue otorgado.
            isPermissionDenied = false
            manager.startUpdatingLocation()
        
        case .denied, .restricted:
            // El permiso fue denegado o restringido por el sistema.
            // En lugar de imprimir, activamos nuestro estado de alerta.
            isPermissionDenied = true
            
        case .notDetermined:
            // El usuario aún no ha decidido. Solicitamos el permiso.
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location
        
        DispatchQueue.main.async {
            self.cameraPosition = .region(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Este print es útil para depuración, pero no afecta al usuario.
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
}

// La extensión no necesita cambios.
extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
                     span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
}
