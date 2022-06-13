//
//  ModelLogic.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import Foundation

final class ModelLogic {
    
    static func loadScores() -> [ScoreModel] {
        do {
            return try JSONLoader(file: "scoresdata", type: [ScoreModel].self)
        } catch JSONErrors.noFile {
            print("fichero no existe")
        } catch JSONErrors.codableError(let error) {
            print("Error en CODABLE con el JSON \(error)")
        } catch JSONErrors.generic(let error) {
            print("Error genérico en la carga \(error)")
        } catch {
            print("Error indeterminado \(error)")
        }
        return []
    }
    
    static let shared = ModelLogic()
    
    var scores:[ScoreModel] {
        didSet {
            Task {
                await saveScores()
            }
        }
    }
    
    var composers:[String] {
        Array(Set(scores.map(\.composer)))
    }
    
    init() {
        self.scores = ModelLogic.loadScores()
    }
    
    func deleteRow(indexPath:IndexPath) {
        scores.remove(at: indexPath.row)
    }
    
    
    func moveRow(from: IndexPath, to:IndexPath) {
        scores.swapAt(from.row, to.row)
    }
    
    func updateScore(score:ScoreModel) -> IndexPath? {
        if let index = scores.firstIndex(where: {$0.id == score.id}) {
            scores[index] = score
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    func addNewScore(title: String, composer: String, year:Int, length: Double) {
        //MARK: .sort que devuelve el valor más grande
        guard let newID = scores.max(by: {$0.id < $1.id}) else { return }
        
        scores.append(ScoreModel(id: newID.id + 1,
                                 title: title,
                                 composer: composer,
                                 year: year,
                                 length: length,
                                 cover: "coverPlaceholder_",
                                 tracks: []))
        
    }
    
    func saveScores() async {
        do {
            try await JSONSaver(file: "scoresdata", json: scores)
        } catch JSONErrors.noFile {
            print("fichero no existe")
        } catch JSONErrors.codableError(let error) {
            print("Error en CODABLE con el JSON \(error)")
        } catch JSONErrors.write(let error) {
            print("Error de escritura de datos \(error.localizedDescription)")
        } catch {
            print("Error indeterminado \(error)")
        }
        NotificationCenter.default.post(name: .detailAlert, object: "Correct Save Data")
    }
}
