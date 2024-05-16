//
//  FetchMarvelStoriesByID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchStories: FetchRequest {
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<StorieData, Error> {
        
        let urlComponents = URLComponents(path: "/\(baseResource.rawValue)/\(resourceId)/stories")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        
        print("Stories --> \(urlComponents.url)")
        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseStorie.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
