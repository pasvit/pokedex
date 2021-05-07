//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

enum PokemonType: String {
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case poison = "poison"
    case bug = "bug"
    case normal = "normal"
    case flying = "flying"
    case electric = "electric"
    case fairy = "fairy"
    case ground = "ground"
    case ghost = "ghost"
    case rock = "rock"
    case fighting = "fighting"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
    case dark = "dark"
    case steel = "steel"
    
    static func getTypeColor(by type: String) -> UIColor {
        switch type {
        case PokemonType.fire.rawValue:
            return .fireColor
        case PokemonType.water.rawValue:
            return .waterColor
        case PokemonType.grass.rawValue, PokemonType.bug.rawValue:
            return .grassColor
        case PokemonType.poison.rawValue, PokemonType.ghost.rawValue, PokemonType.psychic.rawValue, PokemonType.ice.rawValue:
            return .poisonColor
        case PokemonType.normal.rawValue, PokemonType.flying.rawValue, PokemonType.ground.rawValue, PokemonType.normal.rawValue, PokemonType.fighting.rawValue, PokemonType.rock.rawValue, PokemonType.dragon.rawValue:
            return .normalColor
        case PokemonType.electric.rawValue:
            return .electricColor
        case PokemonType.fairy.rawValue:
            return .fairyColor
        case PokemonType.dark.rawValue, PokemonType.steel.rawValue:
            return .darkColor
        default:
            return .white
        }
    }
}

class PokemonViewModel {
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Public var
    // \_____________________________________________________________________/
    var id: Int? {
        didSet {
            self.fetchPokemonImage()
        }
    }
    
    var pokemon: Pokemon
    
    var name: String {
        return self.pokemon.name
    }
    
    var image: UIImage = UIImage(named: "pokemon_image_default")! {
        didSet {
            self.bindImageToView()
        }
    }
    var imageUrlString: String?
    
    var color: UIColor? {
        didSet {
            self.bindColorToView()
        }
    }
    
    var types: [String] = []
    var stats: [PokemonStat] = []
    
    var arePokemonDetailsCompleted: Bool {
        return id != nil && !types.isEmpty && !stats.isEmpty
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Binding var
    // \_____________________________________________________________________/
    var bindImageToView : (() -> ()) = {}
    var bindColorToView : (() -> ()) = {}
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Init
    // \_____________________________________________________________________/
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        self.fetchPokemonDetails()
    }
    
    init(id: Int, name: String, types: [String], stats: [PokemonStat]) {
        self.id = id
        self.pokemon = Pokemon(name: name)
        self.types = types
        self.stats = stats
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Methods
    // \_____________________________________________________________________/
    private func fetchPokemonImage() {
        PokemonService().fetchPokemonImageData(with: self.imageUrlString ?? "") { result in
            switch result {
            case .success(let imageData):
                
                let pokemonImage = UIImage(data: imageData) ?? UIImage(named: "pokemon_image_default")!
                self.image = pokemonImage
                
                // save pokemon to core data 
                if let id = self.id {
                    CoreDataController.shared.addPokemon(name: self.name, pokemonId: id, types: self.types, stats: self.stats, imageData: self.image.pngData()!)
                }                
                
            case .failure(let error):
                break
            }
        }
    }
    
    private func fetchPokemonDetails() {
        PokemonService().fetchPokemonDetails(with: name) { result in
            switch result {
            case .success(let pokemonDetails):
                
                if let artworkImageUrlString = pokemonDetails.sprites?.other?.officialArtwork?.frontDefault {
                    self.imageUrlString = artworkImageUrlString
                } else {
                    self.imageUrlString = pokemonDetails.sprites?.frontDefault
                }
                
                pokemonDetails.stats?.forEach({ statElement in
                    if let statName = statElement.stat?.name {
                        self.stats.append(PokemonStat(name: statName, baseStat: statElement.baseStat))
                    }
                })
                pokemonDetails.types?.forEach({ typeElement in
                    if let typeName = typeElement.type?.name {
                        self.types.append(typeName)
                    }
                })
                if let pokemonType = self.types.first {
                    self.color = PokemonType.getTypeColor(by: pokemonType)
                }
                
                self.id = pokemonDetails.id
                
            case .failure(_):
                break
            }
        }
    }
    
}

struct PokemonStat {
    let name: String
    let baseStat: Int
}
