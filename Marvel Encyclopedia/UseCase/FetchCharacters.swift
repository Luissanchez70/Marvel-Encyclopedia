//
//  MarvelCheracterUseCase.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 26/4/24.
//

import Foundation
import Combine

class FetchCharacters {
    
    func execute() -> AnyPublisher<[Character], Error> {
        
        let urlRequest = URLRequest(components: URLComponents(path: "/characters"))
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCharacter.self)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
    
    func execute(_ characterName: String) -> AnyPublisher<[Character], Error> {
        
        let urlRequest = URLRequest(components: URLComponents(path: "/characters").fetchCharactersByName(characterName))
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCharacter.self)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}

extension URLComponents {
    func fetchCharactersByName(_ characterName: String) -> Self {
        addParams(name: "nameStartsWith", value: characterName)
    }
}
