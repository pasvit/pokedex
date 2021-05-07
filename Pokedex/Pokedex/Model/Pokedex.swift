//
//  Pokedex.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

import Foundation

// MARK: - Pokemon
struct Pokedex: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
