//
//  AppCoordinatorTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 03/05/21.
//

import XCTest
@testable import Pokedex

class AppCoordinatorTests: XCTestCase {
    
    var sut: AppCoordinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AppCoordinator()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_appCoordinator_pokemonDetailTapped_havePushedPokemonDetailViewController() throws {
        //given
        let pokemonName = "bulbasaur"
        let pokemonId = 1
        let pokemonTypes = ["grass", "poison"]
        let pokemonStats = [PokemonStat(name: "attack", baseStat: 49), PokemonStat(name: "hp", baseStat: 45), PokemonStat(name: "speed", baseStat: 45), PokemonStat(name: "special-defense", baseStat: 65), PokemonStat(name: "special-attack", baseStat: 65), PokemonStat(name: "defense", baseStat: 49)]
        let pokemonViewModel = PokemonViewModel(id: pokemonId, name: pokemonName, types: pokemonTypes, stats: pokemonStats)
        
        let rootViewController = UINavigationController(rootViewController: PokemonListViewController())
        
        // when
        sut.pokemonDetailTapped(navigationController: rootViewController, pokemonVM: pokemonViewModel, animated: false)
        
        //then
        XCTAssert(rootViewController.visibleViewController is PokemonDetailViewController)
    }
    
}
