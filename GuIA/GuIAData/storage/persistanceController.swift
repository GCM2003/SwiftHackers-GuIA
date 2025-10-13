//
//  dataManager.swift
//  GuIA
//
//  Created by Guillermo Castañeda Mónico on 08/10/25.
//

import CoreData
import Foundation

//esta es la estructura básica de nuestro persistence controller, lo demás lo añadire por medio de extensiones
struct persistanceController
{
    static let shared = persistanceController() //creamos el objeto persistenceController() que fungirá como base de datos para la app (a esto se le llama singleton)
    
    let container:NSPersistentContainer // creamos el contenedor
    
    
    init()
    {
        container = NSPersistentContainer(name: "appDataModel") //indicamos el nombre de nuestro modelo de datos que vamos a usar
    }
    
    var context: NSManagedObjectContext{
        return container.viewContext
    }
}
