//
//  Comics.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct ResponseComic : Decodable {
    let data: ComicData
}

struct ComicData: Decodable {
    let results: [Comic]
    let offset: Int
}

struct Comic : Decodable {
    let id : Int?
    let title : String?
    let description : String?
    let thumbnail: Thumbnail?
}

