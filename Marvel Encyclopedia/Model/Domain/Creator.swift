//
//  Creator.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import Foundation

struct Creator : Decodable {
    let id : Int?
    let firstName : String?
    let middleName : String?
    let lastName : String?
    let thumbnail: Thumbnail?
}

struct ResponseCreator : Decodable {
    let data : CreatorData
}

struct CreatorData: Decodable {
    let results: [Creator]
}
