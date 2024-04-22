//
//  MainViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit

class MainViewModel {
    
    private var characterList: [MarvelCharacter] = []
    
    init(){
        updateCharacter()
    }
    
    func getList() -> [MarvelCharacter] {
        characterList
    }
    
}
private extension MainViewModel {
    func updateCharacter() {
        do {
            let urlBase: String = "https://gateway.marvel.com/v1/public/characters"
            let list = try ApiClient().executeApi(urlBase: urlBase)
            guard let list = list else { return }
            characterList = list.data.results
        } catch let error {
            print(error.localizedDescription)
        }
       
    }
}
