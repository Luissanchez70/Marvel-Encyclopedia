//
//  MarvelCharacterModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import Foundation

class MarvelCharacterModel : DetailableObject {
    
    var id : Int
    var name : String
    var desc : String
    var thumbnail : Thumbnail
    var comics : [Comic] = []
    var stories : [Storie] = []
    var events : [Event] = []
    var series : [Series] = []
    
    init(_ marvelCharacter : MarvelCharacter) {
        id = marvelCharacter.id
        name = marvelCharacter.name
        desc = marvelCharacter.description
        thumbnail = marvelCharacter.thumbnail
    }
    
    func getName() -> String{
        return name
    }
    
    func getDesc() -> String {
        return desc
    }
    
    func getThumbnail() -> String {
        return "imagePlaceholder"
    }
    
    func getRessources() -> [Any] {
        return [comics,stories,events,series]
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        
        Task {
            do {
                let response:ResponseComic? = try await ApiClient().fetchComics(ByCharacterId: 1011054)
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
    
}
