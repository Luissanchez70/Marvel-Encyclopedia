//
//  MarvelCheracterUseCase.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 26/4/24.
//

import Foundation
import Combine

class MarvelCharacterUseCase {
    
    private let apiClient: ApiClient
    
    init(){
        apiClient = ApiClient()
    }
    
    func execute() -> AnyPublisher<[MarvelCharacter], Error> {
        return apiClient.getMarvelCharacter()
    }
    
    func execute(whereClause: String) -> AnyPublisher<[MarvelCharacter], Error> {
        return apiClient.getMarvelCharacter(whereClause: whereClause)
    }
}
