//
//  getKey.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 13/10/25.
//


import Foundation

enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GuIAPropertyList", ofType: "plist") else {
            fatalError("No se pudo encontrar el archivo 'GuIAPropertyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "apiKey") as? String else {
            fatalError("No se pudo encontrar la clave 'apiKey' en 'GuIAPropertyList.plist'.")
        }
        return value
    }
}

