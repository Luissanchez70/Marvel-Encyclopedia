//
//  Creator.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import Foundation

struct Creator: Decodable {
    let id: Int?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let thumbnail: Thumbnail?
}

struct CreatorData: Decodable {
    let results: [Creator]
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
}

struct ResponseCreator: Decodable {
    let data: CreatorData
}
