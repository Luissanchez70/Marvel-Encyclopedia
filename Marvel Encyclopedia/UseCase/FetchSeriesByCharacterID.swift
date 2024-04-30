//
//  FetchMarvelSeriesByCharacterID.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 30/4/24.
//

import Foundation
import Combine

class FetchSeriesByCharacterID: ApiClient {
    
    func execute(characterID: Int) -> AnyPublisher<[Series], Error> {
        let endpoint = "\(getUrlBase())characters/\(characterID)/series?\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseSeries.self, decoder: JSONDecoder())
            .map{ $0.data.results}
            .eraseToAnyPublisher()
    }
}
