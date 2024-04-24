//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit

class DetailsViewModel {
    
    @Published var name : String?
    @Published var desc : String?
    @Published var thumbnail : String?
    @Published var resources : [Any]?
    var detailableObject : MarvelCharacterModel

    init(marvelCharacter: MarvelCharacter) {
        detailableObject = MarvelCharacterModel(marvelCharacter)
        name = detailableObject.getName()
        desc = detailableObject.getDesc()
        getResourcesComics()
    }
    
    func getResourcesComics() {
        detailableObject.getComics { success in
            if success {
                DispatchQueue.main.sync {
                    self.resources = self.detailableObject.comics
                }
            }
        }
    }
    func getResourcesSeries() {
        detailableObject.getSeries { success in
            if success {
                DispatchQueue.main.sync {
                    self.resources = self.detailableObject.series
                }
            }
        }
    }
}
