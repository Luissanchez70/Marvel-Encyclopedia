//
//  MarvelCharacterModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit
import Combine


class MarvelCharacterModel  {
    
    var id: Int
    var name: String
    var desc: String
    var thumbnail: Thumbnail?
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func getComics(completionHandle: @escaping (Bool) -> Void) {
        FetchComicsByCharacterID().execute(characterID: id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { list in
            DispatchQueue.main.async {
                self.comics = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
    }
    
    func getSeries(completionHandle: @escaping (Bool) -> Void) {
        FetchSeriesByCharacterID().execute(characterID: id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { list in
            DispatchQueue.main.async {
                self.series = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
    }
    
    func getEvents(completionHandle: @escaping (Bool) -> Void){
        FetchEventsByCharacterID().execute(characterID: id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { list in
            DispatchQueue.main.async {
                self.events = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
    }
    
    func getStories(completionHandle: @escaping (Bool) -> Void){
        FetchStoriesByCharacterID().execute(characterID: id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { list in
            DispatchQueue.main.async {
                self.stories = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
    }
}

// MARK: - getters and setters
extension MarvelCharacterModel: DetailableObject {
    
    func getResources() -> [String:[Any]] {
        ["Comics" : comics, "Stories" : stories, "Events" : events, "Series" : series]
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        getComics(completionHandle: completionHandle)
        getSeries(completionHandle: completionHandle)
        getStories(completionHandle: completionHandle)
        getEvents(completionHandle: completionHandle)
    }
}

