//
//  FetchMarvelSeriesByCharacterID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchSeries {
    
    func execute (_ characterID: Int) -> AnyPublisher<SeriesData, Error> {
        
        let urlRequest = URLRequest(components: URLComponents(path: "/characters/\(characterID)/series"))
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseSeries.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
