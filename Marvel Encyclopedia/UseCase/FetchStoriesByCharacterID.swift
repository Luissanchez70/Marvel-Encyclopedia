//
//  FetchMarvelStoriesByID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchStoriesByCharacterID: ApiClient {
    
    func execute(characterID: Int) -> AnyPublisher<[Storie], Error> {
        let endpoint = "\(getUrlBase())characters/\(characterID)/stories?\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseStorie.self, decoder: JSONDecoder())
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}
