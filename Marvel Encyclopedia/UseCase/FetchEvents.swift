//
//  FetchMarvelEventsByCharacterID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchEvents {
    
    func execute (_ characterID: Int) -> AnyPublisher<EventData, Error> {
        
        let urlRequest = URLRequest(components: URLComponents(path: "/characters/\(characterID)/events"))
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseEvent.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
