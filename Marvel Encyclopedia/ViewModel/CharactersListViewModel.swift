//
//  MainViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit
import Combine

class CharactersListViewModel {
    
    @Published var characterList: [Character] = []
    private var getCancellable: AnyCancellable?
    private let fetchMarvelCharacter: FetchCharacter
    private let searchMarvelCharacterByName: FetchCharacterByName
    
    init() {
        fetchMarvelCharacter = FetchCharacter()
        searchMarvelCharacterByName = FetchCharacterByName()
    }
    
    func getCharacters() {
        getCancellable = fetchMarvelCharacter.execute()
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }
    
    func getCharactersFilter(filter: String) {
        let whereClause = "nameStartsWith=\(filter)&"
        getCancellable = searchMarvelCharacterByName.execute(name: whereClause)
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }
}
