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
    
    var scores:[ScoreModel]
    
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
}
