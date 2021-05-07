//
//  PokemonService.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation
import UIKit

class PokemonService {
    let baseUrl: URL? = URL(string: "https://pokeapi.co/api/v2/pokemon")
    
    /// allows you to get a list of pokemon given a certain offset
    /// offset default is 0
    func fetchPokemons(_ url: URL? = nil, offset: Int? = nil, completion: @escaping (Result<Pokedex, PokemonError>) -> Void) {
        DispatchQueue.global().async {
            var newUrl: URL? = url ?? self.baseUrl
            
            switch (url, offset) {
            case (nil, offset):
                newUrl = self.baseUrl?.appending(queryItem: "offset", value: String(offset ?? 20))
            default:
                break
            }
            
            guard let url = newUrl else {
                Log.error("fetchPokemons invalid URL")
                return completion(.failure(PokemonError.invalidURL))
            }
            
            let task = URLSession.shared.dataTask(with: url)
            { (data, response, error) in
                if let jsonData = data {
                    
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        do {
                            let pokedex: Pokedex = try JSONDecoder().decode(Pokedex.self, from: jsonData)
                            completion(.success(pokedex))
                            Log.info("fetchPokemons SUCCESS ->", pokedex)
                        } catch {
                            completion(.failure(PokemonError.decoding))
                            Log.error("fetchPokemons decoding error")
                        }
                    } else {
                        completion(.failure(PokemonError.statusCode))
                        Log.error("fetchPokemons statusCode error")
                    }
                } else {
                    if error != nil {
                        completion(.failure(PokemonError.other(error!)))
                    } else {
                        completion(.failure(PokemonError.genericError))
                    }
                    Log.error("fetchPokemons error")
                }
                
            }
            task.resume()
        }
    }
    
    /// given the url of the pokemon image, it allows you to retrieve the DATA of the image
    func fetchPokemonImageData(with imageUrlString: String, completion: @escaping (Result<Data, PokemonError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url: URL? = URL(string: imageUrlString)
            
            guard let url = url else {
                Log.error("fetchPokemonImageData invalid URL")
                return completion(.failure(PokemonError.invalidURL))
            }
            
            let task = URLSession.shared.dataTask(with: url)
            { (data, response, error) in
                if let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    if let data = data {
                        completion(.success(data))
                        Log.info("fetchPokemonImageData SUCCESS")
                    } else {
                        completion(.failure(PokemonError.decoding))
                        Log.error("fetchPokemonImageData decoding error")
                    }
                } else {
                    completion(.failure(PokemonError.statusCode))
                    Log.error("fetchPokemonImageData statusCode error")
                }
            }
            task.resume()
        }
    }
    
    /// given the name of a pokemon, it allows you to retrieve all the details such as type, stats and id
    func fetchPokemonDetails(with name: String, completion: @escaping (Result<PokemonDetails, PokemonError>) -> Void) {
        DispatchQueue.global().async {
            let url: URL? = self.baseUrl?.appendingPathComponent(name)
            
            guard let url = url else {
                Log.error("fetchPokemonDetails invalid URL")
                return completion(.failure(PokemonError.invalidURL))
            }
            
            let task = URLSession.shared.dataTask(with: url)
            { (data, response, error) in
                if let jsonData = data, let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    do {
                        let pokemonDetails: PokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: jsonData)
                        print(pokemonDetails)
                        completion(.success(pokemonDetails))
                        Log.info("fetchPokemonImageData SUCCESS ->", pokemonDetails)
                    } catch {
                        completion(.failure(PokemonError.decoding))
                        Log.error("fetchPokemonDetails decoding error")
                    }
                } else {
                    completion(.failure(PokemonError.statusCode))
                    Log.error("fetchPokemonDetails statusCode error")
                }
            }
            task.resume()
        }
    }
    
}
