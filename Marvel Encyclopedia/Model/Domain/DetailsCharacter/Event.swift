//
//  Event.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Event : Decodable {
    let id : Int?
    let title : String?
    let description : String?
    let thumbnail: Thumbnail?
}

struct ResponseEvent : Decodable {
    let data : EventData
}

struct EventData: Decodable {
    let results: [Event]
}
