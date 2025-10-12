//
//  UserData.swift
//  GuIA
//
//  Created by Alumno on 09/10/25.
//
import Foundation

// Modelo de datos del usuario
struct UserModel: Identifiable, Codable {
    let id: UUID
    var nombre: String
    var correo: String
    var numero: String
    var gustos: String
    var hobbies: String
    var sexualidad: String
    
    // Preferencias
    var modoOscuro: Bool
    var compartirInfo: Bool
    
    init(
        id: UUID = UUID(),
        nombre: String = "",
        correo: String = "",
        numero: String = "",
        gustos: String = "",
        hobbies: String = "",
        sexualidad: String = "",
        modoOscuro: Bool = false,
        compartirInfo: Bool = false
    ) {
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.numero = numero
        self.gustos = gustos
        self.hobbies = hobbies
        self.sexualidad = sexualidad
        self.modoOscuro = modoOscuro
        self.compartirInfo = compartirInfo
    }
}
