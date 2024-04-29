//
//  MarvelCheracterUseCase.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 26/4/24.
//

import Foundation
import Combine

class FetchMarvelCharacter: ApiClient {
    
    func execute() -> AnyPublisher<[Character], Error> {
        let endpoint = "\(getUrlBase())characters?\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let characterlist = getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseCharacter.self, decoder:JSONDecoder())
            .map{ $0.data.results}
            
        return characterlist.eraseToAnyPublisher()
    }
}
