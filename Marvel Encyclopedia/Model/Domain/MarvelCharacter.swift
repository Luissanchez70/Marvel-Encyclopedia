//
//  MarvelCharacter.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import Foundation
struct Thumbnail: Decodable {
    let path: String
    let `extension`: String
}

struct MarvelCharacter: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail?
}

struct ResponseCharacter: Decodable {
    let data: Data
}

struct Data: Decodable {
    let results: [MarvelCharacter]
}
