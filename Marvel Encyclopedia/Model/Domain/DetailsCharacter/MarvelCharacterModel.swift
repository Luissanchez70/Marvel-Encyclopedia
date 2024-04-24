//
//  MarvelCharacterModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit

protocol DetailableObject {
    func getName() -> String
    func getDesc() -> String
    func getThumbnail() -> String
    func getRessources() -> [[Any]]
    func fetchResources( completionHandle : @escaping (Bool) -> Void )
}

class MarvelCharacterModel  {
    
    var id: Int
    var name: String
    var desc: String
    var thumbnail: Thumbnail
    var comics: [Comic] = []
    var stories: [Storie] = []
    var events: [Event] = []
    var series: [Series] = []
    
    init(_ marvelCharacter : MarvelCharacter) {
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
    
    
    func fetchComics(completionHandle: @escaping (Bool) -> ()){
        Task {
            do {
                let response:ResponseComic? = try await ApiClient().fetchComics(ByCharacterId: id)
                if response != nil{
                    guard let lista = response?.data.results else { return }
                    comics = lista
                    completionHandle(true)
                }else {
                    print("nada")
                }
            } catch let error{
                print(error)
                completionHandle(false)
            }
            
        }
    }
    
    func fetchSeries(completionHandle: @escaping (Bool) -> Void) {
        Task {
            do {
                let response:ResponseSeries? = try await ApiClient().fetchSeries(ByCharacterId: id)
                if response != nil{
                    guard let lista = response?.data.results else { return }
                    series = lista
                    completionHandle(true)
                }else {
                    print("nada")
                }
            } catch let error{
                print(error)
                completionHandle(false)
            }
            
        }
    }
}

// MARK: - getters and setters
extension MarvelCharacterModel: DetailableObject {
    
    func getName() -> String{
        return name
    }
    
    func getDesc() -> String {
        desc
    }
    
    func getThumbnail() -> String {
        return " "
    }
    
    func getRessources() -> [[Any]] {
        return [comics,stories,events,series]
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        
        fetchComics(completionHandle: completionHandle)
        fetchSeries(completionHandle: completionHandle)
    }
}

