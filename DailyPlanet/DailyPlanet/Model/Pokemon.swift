//
//  Pokemon.swift
//  DailyPlanet
//
//  Created by Cao Mai on 4/18/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let next: String?
    let results: [Pokemon]
}

struct Pokemon : Codable{
    let name: String
    let url: String
}

struct GetPokemonImage: Codable {
    let sprites: Image
}

struct Image : Codable {
    let frontDefault: String
}
