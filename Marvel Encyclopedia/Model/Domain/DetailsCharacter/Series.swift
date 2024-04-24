//
//  Series.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Series : Decodable {
    let id : Int?
    let title : String?
    let description : String?
    let thumbnail: Thumbnail?

}

struct ResponseSeries : Decodable {
    let data : SeriesData
}

struct SeriesData: Decodable {
    let results: [Series]
}
