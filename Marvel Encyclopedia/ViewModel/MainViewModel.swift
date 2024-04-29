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
    
    @Published var characterList: [Character] = []
    private var cancellables = Set<AnyCancellable>()
    private let fetchMarvelCharacter: FetchMarvelCharacter
    private let searchMarvelCharacterByName: SearchMarvelCharacterByName
    
    init() {
        fetchMarvelCharacter = FetchMarvelCharacter()
        searchMarvelCharacterByName = SearchMarvelCharacterByName()
    }
    
    func getCharacters() {
        fetchMarvelCharacter.execute().sink { completion in
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
        searchMarvelCharacterByName.execute(whereClause: whereClause).sink { completion in
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
