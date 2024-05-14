//
//  FetchMarvelStoriesByID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchStories {
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<StorieData, Error> {
        
        let urlComponents = URLComponents(path: "/\(baseResource)/\(resourceId)/events")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseStorie.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
