//
//  ComicModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import Foundation
import UIKit

class ComicModel : DetailableObject {
    
    var id: Int
    var name: String
    var desc: String
    var thumbnail: Thumbnail?
    
    var characters : [Character] = []
    var creators: [Creator] = []
    var events : [Event] = []
    var stories: [Storie] = []
    
    init(_ comic : Comic) {
        id = comic.id ?? 0
        name = comic.title ?? "No name found"
        desc = comic.description ?? "No description"
        thumbnail = comic.thumbnail
    }
}

extension ComicModel {

    func getStories(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getStories(comicId: id) { response in
                guard let response = response else { return }
                self.stories = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getCharacters(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getCharacters(comicId: id) { response in
                guard let response = response else { return }
                self.characters = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getCreators(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getCreators(comicId: id) { response in
                guard let response = response else { return }
                self.creators = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getEvents(complition: @escaping (Bool) -> ()){
        do {
            try ApiClient().getEvents(comicId: id) { response in
                guard let response = response else { return }
                self.events = response.data.results
                complition(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension ComicModel {

    func getResources() -> [String:[Any]] {
        ["Characters" : characters, "Creators" : creators, "Stories" : stories, "Events" : events]
    }
    // FIXME: cambiar clausere por publisher de Combine
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        getStories(complition: completionHandle)
        getCreators(complition: completionHandle)
        getStories(complition: completionHandle)
        getCharacters(complition: completionHandle)
    }
}

