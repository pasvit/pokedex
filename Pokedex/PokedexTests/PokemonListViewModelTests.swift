//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 04/05/21.
//

import XCTest
@testable import Pokedex

class PokemonListViewModelTests: XCTestCase {

    var sut: PokemonListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokemonListViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_pokemonListViewModel_pokemons_initiallyPokemonsCount() throws {
        try XCTSkipUnless(
            InternetConnectionManager.isConnectedToNetwork(),
            "Network connectivity needed for this test.")
        
        //given
        let coreDataElements = CoreDataController.shared.getAllPokemons()
        
        //when
        sut = PokemonListViewModel()
        
        //then
        XCTAssert((coreDataElements?.count == 0 && sut.pokemons.isEmpty) || ((coreDataElements!.count > 0 && !sut.pokemons.isEmpty)))
    }
    
}
