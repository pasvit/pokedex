//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation
import UIKit

enum PokemonListViewModelState {
    case notLoad
    case loading
    case finishedLoading
    case pokedexCompleted
    case error(PokemonError)
    
    var isNotLoad: Bool {
        if case .notLoad = self { return true }
        return false
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isPokedexCompleted: Bool {
        if case .pokedexCompleted = self { return true }
        return false
    }
    
    var isFinishedLoading: Bool {
        if case .finishedLoading = self { return true }
        return false
    }
    
    var isError: Bool {
        if case .error(_) = self { return true }
        return false
    }
   
    var errorDescription: String? {
        if case .error(let error) = self {
            //            if error.code != -1009 { // connection offline error
            return error.localizedDescription
            //            }
        }
        return nil
    }
}

class PokemonListViewModel {
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private(set) var
    // \_____________________________________________________________________/
    private(set) var pokemons : [PokemonViewModel] = [] {
        didSet {
            self.bindPokedexToView()
        }
    }
    private(set) var state: PokemonListViewModelState = .notLoad {
        didSet {
            self.bindStateToView()
        }
    }
    var isPokedexCompleted: Bool {
        self.pokedexCount == pokemons.count
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Binding var
    // \_____________________________________________________________________/
    var bindPokedexToView : (() -> ()) = {}
    var bindStateToView : (() -> ()) = {}
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private var
    // \_____________________________________________________________________/
    private var pokedexCount: Int {
        get {
            UserDefaults.standard.integer(forKey: "pokedexCount")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "pokedexCount")
            UserDefaults.standard.synchronize()
        }
    }
    private var pokedex: Pokedex?
    private var canLoadMorePages: Bool {
        self.pokedexCount > pokemons.count  //self.pokedex?.next != nil
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Init
    // \_____________________________________________________________________/
    init() {
        if let savedPokemons = CoreDataController.shared.getAllPokemons(), savedPokemons.count >= self.pokemons.count {
            loadSavedPokemons(savedPokemons)
        } else {
            loadMorePokemons()
        }
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Public Methods
    // \_____________________________________________________________________/
    func loadMorePokemonsIfNeeded(currentPokemon pokemon: PokemonViewModel?) {
        guard let pokemon = pokemon else {
            loadMorePokemons()
            return
        }
        
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -1)
        if isPokedexCompleted {
            state = .pokedexCompleted
        } else if pokemons.firstIndex(where: { $0.id == pokemon.id }) == thresholdIndex {
            if InternetConnectionManager.isConnectedToNetwork() {
                loadMorePokemons()
            }
        }
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Methods
    // \_____________________________________________________________________/
    private func loadMorePokemons() {
        guard state.isNotLoad || (!state.isLoading && canLoadMorePages) else {
            return
        }

        state = .loading
        
        var url: URL?
        
        if let nextUrl = pokedex?.next {
            url = URL(string: nextUrl)
        }
        
        PokemonService().fetchPokemons(url, offset: pokemons.count) { result in
            switch result {
            case .success(let pokedex):
                
                if let pokedexCount = pokedex.count {
                    self.pokedexCount = pokedexCount
                }

                self.pokemons += pokedex.results.map({ pokemon in
                    PokemonViewModel(pokemon: pokemon)
                })
                
                self.pokedex = pokedex
                self.state = .finishedLoading
                
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    private func loadSavedPokemons(_ savedPokemons: [PokemonEntity]) {
        // mapping [PokemonEntity] to [PokemonViewModel] for the view
        var pokemonsVM: [PokemonViewModel] = savedPokemons.compactMap({ pokemon in
            
            let pokemonStats = pokemon.stats?.allObjects.compactMap({ pokemonStatEntity -> PokemonStat? in
                if let statName = (pokemonStatEntity as? PokemonStatEntity)?.name, let baseStat = (pokemonStatEntity as? PokemonStatEntity)?.baseStat {
                    return PokemonStat(name: statName, baseStat: Int(baseStat))
                } else {
                    return nil
                }
            })
                
            if let name =  pokemon.name, let types = pokemon.types, let stats = pokemonStats {
                
                let pokemonViewModel = PokemonViewModel(id: Int(pokemon.id), name: name, types: types, stats: stats)
                if let firstType = types.first {
                    pokemonViewModel.color = PokemonType.getTypeColor(by: firstType)
                }
                if let imageData = pokemon.image {
                    pokemonViewModel.image = UIImage(data: imageData) ?? UIImage(named: "pokemon_image_default")!
                }
                return pokemonViewModel
                
            } else {
                return nil
            }
            
        })
        pokemonsVM.sort{ $0.id! < $1.id!}
        
        /// in case the user has a poor connection and closes the app while loading,
        /// I prevent the saving of partial data in memory
        /// 20 is the number of pokemon loaded on each call to the backend
        /// limit is the query parameter to choose how many pokemon to download from fetchPokemons (limit default: 20)
        let pokemonLimit = 20
        
        let pokemonVMCount = pokemonsVM.count
        let corruptedPokemonsCount = pokemonsVM.count % pokemonLimit
        if corruptedPokemonsCount != 0 && pokemonVMCount != pokedexCount {
            for _ in 0..<corruptedPokemonsCount {
                if let id = pokemonsVM.last?.id {
                    pokemonsVM.removeLast()
                    CoreDataController.shared.deletePokemon(by: id)
                }
            }
        }
        
        self.pokemons = pokemonsVM
    }
    
}
