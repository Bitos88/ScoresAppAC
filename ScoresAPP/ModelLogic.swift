//
//  ModelLogic.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import Foundation

final class ModelLogic {
    
    enum SortType {
        case descendent, ascendent, none
    }
    
    
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
    
    var sortType: SortType = .none
    
    var scores:[ScoreModel] {
        didSet {
            Task {
                await saveScores()
            }
        }
    }
    
    var favorites:[Int] {
        didSet {
            UserDefaults.standard.set(favorites, forKey: "FAVORITES")
        }
    }
    
    var sortScores: [ScoreModel] {
        if search.isEmpty {
            switch sortType {
            case .descendent:
                return scores.sorted(by: { $0.title < $1.title })
            case .ascendent:
                return scores.sorted(by: { $0.title > $1.title })
            case .none:
                return scores.sorted(by: { $0.id > $1.id })
            }
        } else {
            let scoresFilter = scores.filter {
                $0.title.lowercased().hasPrefix(search.lowercased())
            }
            
            switch sortType {
            case .descendent:
                return scoresFilter.sorted(by: { $0.title < $1.title })
            case .ascendent:
                return scoresFilter.sorted(by: { $0.title > $1.title })
            case .none:
                return scoresFilter.sorted(by: { $0.id > $1.id })
            }
        }
        
       
    }
    
    var composers:[String] {
        Array(Set(scores.map(\.composer)))
    }
    
    var search = ""
    
    init() {
        self.scores = ModelLogic.loadScores()
        self.favorites = UserDefaults.standard.array(forKey: "FAVORITES") as? [Int] ?? []
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
                                 cover: "coverPlaceholder",
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
    
    func toggleFavorites(id:Int) {
        let list = sortScores[id]
        
        guard let realID = scores.firstIndex(where: {$0.id == list.id}) else {
            return
        }
        
        if favorites.contains(realID) {
            favorites.removeAll() {
                $0 == id
            }
        } else {
            favorites.append(realID)
        }
    }
    
    func isFavorite(id:Int) -> Bool {
        let list = sortScores[id]
        
        guard let realID = scores.firstIndex(where: {$0.id == list.id}) else {
            return false
        }
        
        
        return favorites.contains(realID)
    }
    
    func getFavorite(id:Int) -> ScoreModel {
        scores[favorites[id]]
    }
}
