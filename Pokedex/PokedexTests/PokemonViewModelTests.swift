//
//  PokemonViewModelTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 03/05/21.
//

import XCTest
@testable import Pokedex

class PokemonViewModelTests: XCTestCase {

    var sut: PokemonViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokemonViewModel(pokemon: Pokemon(name: "bulbasaur"))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_pokemonViewModel_havePokemonName() throws {
        //when
        let pokemon = Pokemon(name: "bulbasaur")
        
        // given
        sut = PokemonViewModel(pokemon: pokemon)
        
        //then
        XCTAssert(!sut.name.isEmpty)
    }
    
    func test_pokemonViewModel_havePokemonUrl() throws {
        //when
        let pokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/bulbasaur")
        
        // given
        sut = PokemonViewModel(pokemon: pokemon)
        
        //then
        XCTAssert(!sut.pokemon.url!.isEmpty)
    }
    
    func test_pokemonViewModel_isRightPokemonName() throws {
        //when
        let pokemon = Pokemon(name: "bulbasaur")
        
        // given
        sut = PokemonViewModel(pokemon: pokemon)
        
        //then
        XCTAssert(sut.name == pokemon.name)
    }
    
    func test_pokemonViewModel_havePokemonDetails() throws {
        //when
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        
        //given
        sut = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //then
        XCTAssert(!sut.name.isEmpty && !(sut.id == nil) && !sut.types.isEmpty && !sut.stats.isEmpty)
    }
    
    func test_pokemonViewModel_haveRightPokemonNameAndId() throws {
        //when
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        
        //given
        sut = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //then
        XCTAssert(sut.name == pokemonName && sut.id == pokemonId)
    }
    
    func test_pokemonViewModel_haveRightPokemonTypes() throws {
        //when
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        
        //given
        sut = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        var rightTypes = false
        
        sut.types.forEach { sutType in
            pokemonTypes.forEach { pokemonType in
                if sutType == pokemonType {
                    rightTypes = true
                }
            }
        }
        
        //then
        XCTAssert(rightTypes)
    }
    
    func test_pokemonViewModel_haveRightPokemonStats() throws {
        //when
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        
        //given
        sut = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        var rightStats = false
        
        sut.stats.forEach { sutStat in
            pokemonStats.forEach { pokemonStat in
                if sutStat.baseStat == pokemonStat.baseStat && pokemonStat.name == sutStat.name {
                    rightStats = true
                }
            }
        }
        
        //then
        XCTAssert(rightStats)
    }

    func test_pokemonViewModel_arePokemonDetailsCompleted() throws {
        //when
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        
        //given
        sut = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //then
        XCTAssert(sut.arePokemonDetailsCompleted)
    }
    
}
