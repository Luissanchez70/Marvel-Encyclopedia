//
//  MarvelCharacterModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit



class MarvelCharacterModel  {
    
    var id: Int
    var name: String
    var desc: String
    var thumbnail: Thumbnail?
    
    var comics: [Comic] = []
    var stories: [Storie] = []
    var events: [Event] = []
    var series: [Series] = []
    
    init(_ marvelCharacter : Character) {
        id = marvelCharacter.id
        name = marvelCharacter.name
        desc = marvelCharacter.description
        thumbnail = marvelCharacter.thumbnail
    }
}
// MARK: - Fetch Comics, Series, stories, events
extension MarvelCharacterModel {
    
    func getComics(complition: @escaping (Bool) -> ()) {
        do {
            try ApiClient().getComics(characterId: id) { response in
                guard let response = response else { return }
                self.comics = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getSeries(complition: @escaping (Bool) -> ()) {
        do {
            try ApiClient().getSeries(characterId: id) { response in
                guard let response = response else { return }
                self.series = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getEvents(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getEvents(characterId: id) { response in
                guard let response = response else { return }
                self.events = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getStories(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getStories(characterId: id) { response in
                guard let response = response else { return }
                self.stories = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

// MARK: - getters and setters
extension MarvelCharacterModel: DetailableObject {
    
    func getResources() -> [String:[Any]] {
        ["Comics" : comics, "Stories" : stories, "Events" : events, "Series" : series]
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        getComics(complition: completionHandle)
        getSeries(complition: completionHandle)
        getStories(complition: completionHandle)
        getEvents(complition: completionHandle)
    }
}

