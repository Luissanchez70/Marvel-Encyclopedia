//
//  Event.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

struct Event: Decodable, ResourceItem {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}

struct EventData: Decodable {
    let results: [Event]
}

struct ResponseEvent: Decodable {
    let data: EventData
}
