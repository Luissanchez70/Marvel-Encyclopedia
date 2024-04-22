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
    }
    
    func getCharacters(complition: @escaping (Bool) -> () ) {
        updateCharacter(complition:  complition)
    }
    
    func getList() -> [MarvelCharacter] {
        characterList
    }
    
}
private extension MainViewModel {
    
    func updateCharacter(complition: @escaping (Bool) -> () ) {
        do {
            let urlBase: String = "https://gateway.marvel.com/v1/public/characters"
            try ApiClient().executeApi(urlBase: urlBase) { list in
                guard let list = list else { return }
                self.characterList = list.data.results
                complition(true)
            }
           
        } catch let error {
            print(error.localizedDescription)
        }
       
    }
}
