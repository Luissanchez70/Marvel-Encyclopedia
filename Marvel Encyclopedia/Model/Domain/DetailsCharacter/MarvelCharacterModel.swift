//
//  MarvelCharacterModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit

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
        return " "
    }
    
    func getRessources() -> [[Any]] {
        return [comics,stories,events,series]
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        
        fetchComics(completionHandle: completionHandle)
        fetchSeries(completionHandle: completionHandle)
    }
    
    func fetchComics(completionHandle: @escaping (Bool) -> Void){
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
