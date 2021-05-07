//
//  PokemonDetails.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let name: String
    let url: String?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    init(name: String) {
        self.name = name
        self.url = nil
    }
}
