//
//  FetchMarvelComicsByCharacterID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchComics {
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<ComicData, Error> {
        
        let urlComponents = URLComponents(path: "/\(baseResource)/\(resourceId)/comics")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseComic.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
