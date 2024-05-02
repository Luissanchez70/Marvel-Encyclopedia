//
//  Comics.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Comic: Decodable, ResourceItem {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}

struct ComicData: Decodable {
    let results: [Comic]
    let offset : Int
    let limit : Int
    let total : Int
    let count : Int
}

struct ResponseComic: Decodable {
    let data: ComicData
}
