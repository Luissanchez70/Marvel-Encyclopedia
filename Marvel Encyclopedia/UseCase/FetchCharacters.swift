//
//  MarvelCheracterUseCase.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 26/4/24.
//

import Foundation
import Combine

class FetchCharacters {
    
    func execute(limit:Int, offset:Int) -> AnyPublisher<CharacterData, Error> {
            let urlComponents = URLComponents(path: "/characters")
                .addParams(name: "limit", value: "\(limit)")
                .addParams(name: "offset", value: "\(offset)")

            let urlRequest = URLRequest(components: urlComponents)
            return URLSession.shared
                .fetch(for: urlRequest, with: ResponseCharacter.self)
                .map { $0.data }
                .eraseToAnyPublisher()
    }
    
    func execute(_ characterName: String, limit:Int, offset:Int) -> AnyPublisher<CharacterData, Error> {
        
        let urlComponents = URLComponents(path: "/characters")
            .addParams(name: "nameStartsWith", value: characterName)
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")
        
        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCharacter.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

extension FetchCharacters: FetchRequest{
    
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<CharacterData, Error> {
        
        let urlComponents = URLComponents(path: "/\(baseResource.rawValue)/\(resourceId)/characters")
            .addParams(name: "limit", value: "\(limit)")
            .addParams(name: "offset", value: "\(offset)")

        let urlRequest = URLRequest(components: urlComponents)
        return URLSession.shared
            .fetch(for: urlRequest, with: ResponseCharacter.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

extension URLComponents {
    func fetchCharactersByName(_ characterName: String) -> Self {
        addParams(name: "nameStartsWith", value: characterName)
    }
}
