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
    @Published var errorActual: CustomError? = nil
    private var getCancellable: AnyCancellable?
    private var okResponse: Bool = false
 
    func getCharacters(currentPage: Int) {
        getCancellable = FetchCharacters().execute(limit: 20, offset: currentPage * 20)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.okResponse = true
            case .failure(let error):
                self.okResponse = false
                self.errorActual = error as? CustomError
            }
        }, receiveValue: { characterData in
            self.okResponse = true
            self.numberPage = characterData.total / 20
            self.characterList = characterData.results
        })
    
    }

    func getCharactersFilter(filter: String, currentPage: Int) {
        getCancellable = FetchCharacters().execute(filter, limit: 20, offset: currentPage * 20)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.okResponse = true
            case .failure(let error):
                self.okResponse = false
                self.characterList = []
                self.errorActual = error as? CustomError
            }
        }, receiveValue: { characterData in
            self.okResponse = true
            self.numberPage = characterData.total / 20
            self.characterList = characterData.results
        })
    }
}
