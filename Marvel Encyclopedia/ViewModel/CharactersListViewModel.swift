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

    func getCharacters() {
        getCancellable = FetchCharacters().execute()
            .map { $0.results}
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }

    func getCharactersFilter(filter: String) {
        getCancellable = FetchCharacters().execute(filter)
            .map { $0.results}
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }
}
