//
//  Series.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Series : Codable {
    let id : Int
    let title : String
    let description : String
}

struct ResponseSeries : Codable {
    let data : SeriesData
}

struct SeriesData: Codable {
    let results: [Series]
}
