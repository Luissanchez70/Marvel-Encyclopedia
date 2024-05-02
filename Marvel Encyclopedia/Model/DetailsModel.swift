//
//  DetailsModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

enum ResourceType{
    case character
    case comic
    case creator
    case event
    case serie
    case story
}

class DetailsModel{
    
    var id: Int
    var name: String
    var desc: String
    var thumbnail: Thumbnail?
    var type : ResourceType
    
    var resources : [String : [Any]] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init( from resorceItem: ResourceItem, resourceTye : ResourceType ) {
        id = resorceItem.id ?? 1
        name = resorceItem.title ?? "No title"
        desc = resorceItem.description ?? "No description"
        thumbnail = resorceItem.thumbnail
        type = resourceTye
    }
    
    init( from character : Character, resourceTye : ResourceType ) {
        id = character.id
        name = character.name
        desc = character.description
        thumbnail = character.thumbnail
        type = resourceTye
    }
    
    init( from creator : Creator, resourceTye : ResourceType ) {
        id = creator.id ?? 0
        name = "\(creator.firstName!) \(creator.lastName!)"
        desc = "No description"
        thumbnail = creator.thumbnail
        type = resourceTye
    }
    
    func getResources() -> [String : [Any]] {
        return resources
    }
    
    func getResources(_ completionHandle: @escaping (Bool) -> (),
                 _ baseResource : String,
                 _ targetResource : String,
                 _ targetType : ResourceType){
        
        FetchAnyByAnyIDList().execute(baseResource: baseResource, baseID: id, targetResource: targetResource, targetType: targetType).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { list in
            DispatchQueue.main.async {
                self.resources[targetResource] = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
        
    }
        
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        
        var baseResource = " "
        switch type {
        case .comic:
            baseResource = "comics"
        case .character:
            baseResource = "characters"
        case .creator:
            baseResource = "creators"
        case .event:
            baseResource = "events"
        case .serie:
            baseResource = "series"
        case .story:
            baseResource = "stories"
        }
        
        if type != .comic {
            getResources(completionHandle, baseResource, "comics", .comic)
        }
        if type != .character && type != .creator {
            getResources(completionHandle, baseResource, "characters", .character)
        }
        if type != .creator && type != .character {
            getResources(completionHandle, baseResource, "creators", .creator)
        }
        if type != .event {
            getResources(completionHandle, baseResource, "events", .event)
        }
        if type != .comic && type != .serie {
            getResources(completionHandle, baseResource,"series", .serie)
        }
        if type != .story {
            getResources(completionHandle, baseResource, "stories", .story)
        }
        
    }
    
    func getName() -> String{
        name
    }
    
    func getDesc() -> String {
        desc
    }
    
    func getThumbnail() -> Thumbnail? {
        thumbnail
    }
}
