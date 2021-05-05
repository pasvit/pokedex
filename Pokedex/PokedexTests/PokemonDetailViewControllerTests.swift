//
//  PokemonDetailViewControllerTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 03/05/21.
//

import XCTest
@testable import Pokedex

class PokemonDetailViewControllerTests: XCTestCase {

    var sut: PokemonDetailViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokemonDetailViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
   
    func test_pokemonViewModel_havePokemonViewModel() throws {
        //given
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        let pokemonViewModel = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //when
        sut = PokemonDetailViewController(pokemon: pokemonViewModel)
        
        //then
        XCTAssert(sut.pokemonVM != nil)
    }
    
    func test_pokemonViewModel_havePokemonDetails() throws {
        //given
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        let pokemonViewModel = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //when
        sut = PokemonDetailViewController(pokemon: pokemonViewModel)
        
        //then
        XCTAssert(!sut.pokemonVM!.name.isEmpty && (sut.pokemonVM!.id != nil) && !sut.pokemonVM!.types.isEmpty && !sut.pokemonVM!.stats.isEmpty)
    }

    func test_pokemonViewModel_haveRightPokemonTypes() throws {
        //given
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        let pokemonViewModel = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //when
        sut = PokemonDetailViewController(pokemon: pokemonViewModel)
        
        var rightTypes = false
        
        sut.pokemonVM!.types.forEach { sutType in
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
        //given
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        let pokemonViewModel = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        //when
        sut = PokemonDetailViewController(pokemon: pokemonViewModel)
        
        var rightStats = false
        
        sut.pokemonVM!.stats.forEach { sutStat in
            pokemonStats.forEach { pokemonStat in
                if sutStat.baseStat == pokemonStat.baseStat && pokemonStat.name == sutStat.name {
                    rightStats = true
                }
            }
        }
        
        //then
        XCTAssert(rightStats)
    }
    
}
