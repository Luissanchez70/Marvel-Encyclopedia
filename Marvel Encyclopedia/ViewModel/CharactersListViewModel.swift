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
    @Published var numberPage = 0
    private var getCancellable: AnyCancellable?
 
    func getCharacters(currentPage: Int) {
        getCancellable = FetchCharacters().execute(limit: 20, offset: currentPage * 20)
            .map { response in
                self.numberPage = response.total / 20
                return response.results
            }
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }

    func getCharactersFilter(filter: String, currentPage: Int) {
        getCancellable = FetchCharacters().execute(filter, limit: 20, offset: currentPage * 20)
            .map { response in
                self.numberPage = (response.total / 20)
                return response.results
            }
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
    }
}
