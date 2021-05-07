//
//  String+extensions.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
}
