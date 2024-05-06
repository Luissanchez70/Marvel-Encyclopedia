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
<<<<<<< HEAD
    let data: DataCharacter
}
struct DataCharacter: Decodable {
=======
    let data: CharacterData
    
}

struct CharacterData: Decodable {
    let offset : Int
    let limit : Int
    let total : Int
    let count : Int
>>>>>>> 19dc7e8209bd80ebf3487b24c3dd2091a89cdf0a
    let results: [Character]
}
