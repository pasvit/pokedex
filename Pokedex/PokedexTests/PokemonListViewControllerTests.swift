//
//  PokemonListViewControllerTests.swift
//  PokedexTests
//
//  Created by Pasquale Vitulli on 03/05/21.
//

import XCTest
@testable import Pokedex

class PokemonListViewControllerTests: XCTestCase {
    
    var sut: PokemonListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PokemonListViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_hasATableView() {
        XCTAssertNotNil(sut.pokemonsTableView)
    }
    
    func test_TableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(sut.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:cellForRowAt:))))
    }
    
    func test_TableViewConformsToTableViewDelegateProtocol_withDidSelectRowAt() {
        XCTAssertTrue(sut.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:didSelectRowAt:))))
    }
     
    func test_TableViewConformsToUISearchResultsUpdating() {
        XCTAssertTrue(sut.conforms(to: UISearchResultsUpdating.self))
    }
}
