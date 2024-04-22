//
//  Comics.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct ResponseComic : Codable {
    let data: ComicData
}

struct ComicData: Codable {
    let results: [Comic]
    let offset: Int
}

struct Comic : Codable {
    let id : Int
    let title : String
    let description : String
}

