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

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail?
}

struct ResponseCharacter: Decodable {
    let data: DataCharacter
}
struct DataCharacter: Decodable {
    let results: [Character]
}
