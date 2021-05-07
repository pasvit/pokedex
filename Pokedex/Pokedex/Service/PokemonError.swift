//
//  PokemonError.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation

enum PokemonError: Error {
    case statusCode
    case decoding
    case invalidURL
    case genericError
    case noConnection
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .statusCode:
            return "Status Code Error"
        case .decoding:
            return "Decoding Error"
        case .invalidURL:
            return "Invalid URL Error"
        case .genericError:
            return "Generic Error"
        case .noConnection:
            return "Connection Offline Error: I cannot update or load other pokemon"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    var code: Int? {
        switch self {
        case .other(let error):
            return (error as NSError).code
        default:
            return nil
        }
    }

}
