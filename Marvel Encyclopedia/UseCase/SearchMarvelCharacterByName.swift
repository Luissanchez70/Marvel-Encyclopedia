//
//  SearchMarvelCharacterByName.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 29/4/24.
//

import Foundation
import Combine

class SearchMarvelCharacterByName: ApiClient {
    
    func execute(whereClause: String) -> AnyPublisher<[Character], Error> {
        let endpoint = "\(getUrlBase())characters?\(whereClause)&\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let characterlist = getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseCharacter.self, decoder: JSONDecoder())
            .map{$0.data.results}
        return characterlist.eraseToAnyPublisher()
    }
}
