//
//  FetchCreator.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 14/5/24.
//

import Foundation
import Combine

class FetchCreator: FetchRequest {
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int)
    -> AnyPublisher<CreatorData, Error> {
        let urlComponents = URLComponents(path: "/\(baseResource.rawValue)/\(resourceId)/creators")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        print("-----> \(urlComponents.url)")

        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCreator.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
