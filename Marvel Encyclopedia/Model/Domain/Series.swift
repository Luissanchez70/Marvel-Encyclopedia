//
//  Series.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Series: Decodable, ResourceItem {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}

struct SeriesData: Decodable {
    let results: [Series]
}

struct ResponseSeries: Decodable {
    let data: SeriesData
}
