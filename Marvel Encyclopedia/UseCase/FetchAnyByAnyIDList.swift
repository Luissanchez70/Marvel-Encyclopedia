//
//  FetchAnyByAnyID.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

class FetchAnyByAnyIDList: ApiClient {
    func execute(baseResource : String, baseID: Int, targetResource : String, targetType : ResourceType, limit : Int = 5) -> AnyPublisher<[Any], Error> {
        let endpoint = "\(getUrlBase())\(baseResource)/\(baseID)/\(targetResource)?limit=\(limit)&\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        switch targetType {
        case .character:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseCharacter.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        case .comic:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseComic.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        case .creator:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseCreator.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        case .event:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseEvent.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        case .serie:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseSeries.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        case .story:
            return getUrlSession().dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseStorie.self, decoder: JSONDecoder())
                .map { $0.data.results }
                .eraseToAnyPublisher()
        }
    }
     
}
