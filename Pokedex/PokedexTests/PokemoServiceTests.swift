//
//  PokemoServiceTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 02/05/21.
//

import XCTest
@testable import Pokedex

class PokemoServiceTests: XCTestCase {
    var sut: PokemonService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokemonService()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_fetchPokemons_withSuccessResult() throws {
        try XCTSkipUnless(
            InternetConnectionManager.isConnectedToNetwork(),
            "Network connectivity needed for this test.")
        
        // given
        sut = PokemonService()
        
        let promise = expectation(description: "Success")
        
        // when
        sut?.fetchPokemons(completion: { result in
            switch result {
            // then
            case .success(let pokedex):
                XCTAssert(pokedex.count! > 0)
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
        })
   
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchPokemonImageData_getImageData_withSuccessResult() throws {
        try XCTSkipUnless(
            InternetConnectionManager.isConnectedToNetwork(),
            "Network connectivity needed for this test.")
        
        // given
        sut = PokemonService()
        
        let promise = expectation(description: "Success")
        
        // bulbasaur image url
        let imageUrlString: String  = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
        
        // when
        sut.fetchPokemonImageData(with: imageUrlString, completion: { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                XCTAssert(image != nil)
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
        })
   
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchPokemonDetails_getRightPokemonDetail_withSuccessResult() throws {
        try XCTSkipUnless(
            InternetConnectionManager.isConnectedToNetwork(),
            "Network connectivity needed for this test.")
        
        // given
        sut = PokemonService()
        
        let promise = expectation(description: "Success")
        
        let firstPokemonId: Int = 1
        let firstPokemonName: String = "bulbasaur"
        
        // when
        sut.fetchPokemonDetails(with: firstPokemonName, completion: { result in
            switch result {
            case .success(let pokemonDetails):
                XCTAssert(pokemonDetails.id == firstPokemonId)
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
        })
   
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchPokemonDetails_WithSuccessResult() throws {
        try XCTSkipUnless(
            InternetConnectionManager.isConnectedToNetwork(),
            "Network connectivity needed for this test.")
        
        // given
        sut = PokemonService()
        
        let promise = expectation(description: "Success")
        
        let firstPokemonName: String = "bulbasaur"
        
        // when
        sut.fetchPokemonDetails(with: firstPokemonName, completion: { result in
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
        })
   
        wait(for: [promise], timeout: 5)
    }
    
}
