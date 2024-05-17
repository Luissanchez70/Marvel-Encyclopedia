//
//  FetchMarvelEventsByCharacterID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchEvents: FetchRequest{
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<EventData, Error> {
        
        let urlComponents = URLComponents(path: "/\(baseResource.rawValue)/\(resourceId)/events")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        print("-----> \(urlComponents.url)")

        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseEvent.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
