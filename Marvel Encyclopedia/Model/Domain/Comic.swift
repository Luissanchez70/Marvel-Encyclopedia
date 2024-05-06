//
//  Comics.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct ResponseComic: Decodable {
    let data: ComicData
}

struct ComicData: Decodable {
    let results: [Comic]
    let offset: Int
}

struct Comic: Decodable, ResourceItem {
    let id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}
