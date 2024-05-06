//
//  SearchMarvelCharacterByName.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 29/4/24.
//

import Foundation
import Combine

class FetchCharacterByName {
    
    func execute(name: String) -> AnyPublisher<[Character], Error> {
        let urlRequest = URLRequest.fetchCharacter(name: name)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCharacter.self)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}

private extension URLRequest {
    static func fetchCharacter(name: String) -> Self {
        URLRequest(components: .fetchCharacter(name: name))
    }
}

private extension URLComponents {
    static func fetchCharacter(name: String) -> Self {
        URLComponents(path: "/characters")
            .newParam(name: "nameStartsWith", value: name)
    }
}
