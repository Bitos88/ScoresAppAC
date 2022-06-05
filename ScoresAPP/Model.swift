//
//  Model.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import Foundation

struct ScoreModel:Codable {
    let id:Int
    let title:String
    let composer: String
    let year:Int
    let length: Double
    let cover:String
    let tracks:[String]
}

