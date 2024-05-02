//
//  Storie .swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Storie: Decodable, ResourceItem {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}

struct StorieData: Decodable {
    let results: [Storie]
}

struct ResponseStorie: Decodable {
    let data: StorieData
}
