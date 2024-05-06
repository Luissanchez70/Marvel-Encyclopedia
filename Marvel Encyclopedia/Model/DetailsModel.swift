//
//  DetailsModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

enum ResourceType : String {
    case character = "characters"
    case comic = "comics"
    case creator = "creators"
    case event = "events"
    case serie = "series"
    case story = "stories"
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
    
    func getName() -> String{
        name
    }
    
    func getDesc() -> String {
        desc
    }
    
    func getThumbnail() -> Thumbnail? {
        thumbnail
    }
    
    func getResources(_ completionHandle: @escaping (Bool) -> (),
                 _ baseResource : ResourceType,
                 _ targetResource : ResourceType){
        
        FetchAnyByAnyIDList().execute(baseResource: baseResource, baseID: id, targetResource: targetResource).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                let list = self.decodeResponse(data: data, targetType: targetResource)
                self.resources[targetResource.rawValue] = list
                completionHandle(true)
            }
        }.store(in: &cancellables)
        
    }
    
    func decodeResponse(data: Data, targetType : ResourceType) -> [Any] {
        do {
            switch targetType {
            case .character:
                return try JSONDecoder().decode(ResponseCharacter.self, from: data).data.results
            case .comic:
                return try JSONDecoder().decode(ResponseComic.self, from: data).data.results
            case .creator:
                return try JSONDecoder().decode(ResponseCreator.self, from: data).data.results
            case .event:
                return try JSONDecoder().decode(ResponseEvent.self, from: data).data.results
            case .serie:
                return try JSONDecoder().decode(ResponseSeries.self, from: data).data.results
            case .story:
                return try JSONDecoder().decode(ResponseStorie.self, from: data).data.results
            }
        } catch {
            print(error.localizedDescription.localizedLowercase)
        }
        return []
    }
        
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
        if type != .comic {
            getResources(completionHandle,  type , .comic)
        }
        if type != .character && type != .creator {
            getResources(completionHandle,  type , .character)
        }
        if type != .creator && type != .character {
            getResources(completionHandle,  type , .creator)
        }
        if type != .event {
            getResources(completionHandle,  type ,.event)
        }
        if type != .comic && type != .serie {
            getResources(completionHandle,  type ,.serie)
        }
        if type != .story {
            getResources(completionHandle,  type , .serie)
        }
    }
}
