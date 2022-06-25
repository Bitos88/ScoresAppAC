//
//  JSONLoader.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import Foundation

enum JSONErrors:Error {
    case noFile, codableError(String), generic(Error), write(Error)
}

func JSONLoader<Tipo:Codable>(file:String, type:Tipo.Type) throws -> Tipo {
    
    //MARK: RECUPERO JSON DEL BUNDLE
    guard let url = Bundle.main.url(forResource: "\(file)", withExtension: "json"),
          let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else {
        throw JSONErrors.noFile
    }
    //INICIALIZAMOS DATA
    print(doc)
    var fullURL = doc.appendingPathComponent("\(file)").appendingPathExtension("json")
    if !FileManager.default.fileExists(atPath: fullURL.path) {
        fullURL = url
    }
    var data:Data
    
    do {
        //CARGAMOS EL DATA
        data = try Data(contentsOf: fullURL)
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


func JSONSaver<Tipo:Codable>(file:String, json:Tipo) async throws {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw JSONErrors.noFile
    }
    //MARK: URL COMPLETA SOBRE LA QUE GRABO
    let fullURL = url.appendingPathComponent("\(file)").appendingPathExtension("json")
    
    var data:Data
    
    do {
        data = try JSONEncoder().encode(json)
    } catch {
        throw JSONErrors.codableError(error.localizedDescription)
    }
    
    do {
        try data.write(to: fullURL, options: .atomic)
    } catch  {
        throw JSONErrors.codableError(error.localizedDescription)
    }
}

//MARK: CARGA LOS DATOS DESDE EL DOCUMENTO GUARDADO EN LOCAL (JSONSaver)
func JSONLoaderFromLocal<Tipo:Codable>(file:String, type:Tipo.Type) throws -> Tipo {
    
    //MARK: RECUPERO JSON DEL BUNDLE
    guard let url = Bundle.main.url(forResource: "\(file)", withExtension: "json"),
          let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else {
        throw JSONErrors.noFile
    }
    //INICIALIZAMOS DATA
    _ = doc.appendingPathComponent("\(file)").appendingPathExtension("json")

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
