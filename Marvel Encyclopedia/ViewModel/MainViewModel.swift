//
//  MainViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit
import Combine

class MainViewModel {
    
    @Published var characterList: [MarvelCharacter] = []
    private var cancellables = Set<AnyCancellable>()
    private let marvelCharacterUseCase: MarvelCharacterUseCase
    
    init() {
        marvelCharacterUseCase = MarvelCharacterUseCase()
    }
    
    func getCharacters() {
        marvelCharacterUseCase.execute().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { list in
            self.characterList = list
        }.store(in: &cancellables)
    }
    
    func getCharactersFilter(filter: String) {
        let whereClause = "nameStartsWith=\(filter)&"
        marvelCharacterUseCase.execute(whereClause: whereClause).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { list in
            self.characterList = list
        }.store(in: &cancellables)
    }
    
}
