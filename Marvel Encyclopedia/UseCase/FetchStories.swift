//
//  FetchMarvelStoriesByID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchStories {
    
    func execute (_ characterID: Int) -> AnyPublisher<[Storie], Error> {
        
        let urlRequest = URLRequest(components: URLComponents(path: "/characters/\(characterID)/stories"))
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseStorie.self)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}
