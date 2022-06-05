//
//  JSONLoader.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import Foundation

enum JSONErrors:Error {
    case noFile, codableError(String), generic(Error)
}

func JSONLoader<Tipo:Codable>(file:String, type:Tipo.Type) throws -> Tipo {
    
    //MARK: RECUPERO JSON DEL BUNDLE
    guard let url = Bundle.main.url(forResource: "\(file)", withExtension: "json") else {
        throw JSONErrors.noFile
    }
    //INICIALIZAMOS DATA
    var data:Data
    
    do {
        //CARGAMOS EL DATA
        data = try Data(contentsOf: url)
    } catch {
        throw JSONErrors.generic(error)
    }
    
    do {
        //RECUPERAMOS Y DEVOLVEMOS EL JSONDECODER
        return try JSONDecoder().decode(Tipo.self, from: data)
    } catch  {
        throw JSONErrors.codableError(error.localizedDescription)
    }
}
