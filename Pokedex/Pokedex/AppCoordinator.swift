//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 02/05/21.
//

import UIKit

class AppCoordinator {
    
    static let shared = AppCoordinator()
 
    func pokemonDetailTapped(navigationController: UINavigationController, pokemonVM: PokemonViewModel, animated: Bool = true) {
        let detailViewController = PokemonDetailViewController(pokemon: pokemonVM)
        navigationController.pushViewController(detailViewController, animated: animated)
    }
    
}
