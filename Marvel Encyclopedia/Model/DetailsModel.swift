//
//  DetailsModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

enum ResourceType: String {
    case character = "characters"
    case comic = "comics"
    case creator = "creators"
    case event = "events"
    case serie = "series"
    case story = "stories"
}

class DetailsModel {
    
    private var id: Int
    private var name: String
    private var desc: String?
    private var thumbnail: Thumbnail?
    private var type : ResourceType
    private var resources: [String : [Any]] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var requests: [Any] = [FetchComics(), FetchEvents(), FetchSeries(), FetchCreator(), FetchStories(),FetchCreator(), FetchCharacters()]
    
    init( from resorceItem: ResourceItem, resourceTye: ResourceType ) {
        id = resorceItem.id ?? 1
        name = resorceItem.title ?? "No title"
        desc = resorceItem.description
        thumbnail = resorceItem.thumbnail
        type = resourceTye
    }
    
    init( from character: Character, resourceTye: ResourceType ) {
        id = character.id
        name = character.name
        desc = character.description
        thumbnail = character.thumbnail
        type = resourceTye
    }
    
    init( from creator: Creator, resourceTye: ResourceType ) {
        id = creator.id ?? 0
        name = "\(creator.firstName!) \(creator.lastName!)"
        desc = nil
        thumbnail = creator.thumbnail
        type = resourceTye
    }
    
    func getType() -> ResourceType {
        type
    }
    
    func getId() -> Int{
        id
    }
    
    func getResources() -> [String : [Any]] {
        resources
    }
    
    func getName() -> String {
        name
    }
    
    func getDesc() -> String? {
        desc
    }
    
    func getThumbnail() -> Thumbnail? {
        thumbnail
    }
    
    func fetchResources(completionHandle: @escaping (Bool) -> Void) {
    
        for request in requests {
            
            if let comicRequest = request as? FetchComics {
                addToDiccionary(request: comicRequest, key: "Comics", completion: completionHandle)
            } else  if let eventRequest = request as? FetchEvents {
                addToDiccionary(request: eventRequest, key: "Events", completion: completionHandle)
            } else  if let seriesRequest = request as? FetchSeries {
                addToDiccionary(request: seriesRequest, key: "Series", completion: completionHandle)
            } else  if let storieRequest = request as? FetchStories {
                addToDiccionary(request: storieRequest, key: "Stories", completion: completionHandle)
            } else  if let cretorRequest = request as? FetchCreator {
                addToDiccionary(request: cretorRequest, key: "Creators", completion: completionHandle)
            } else  if let characterRequest = request as? FetchCreator {
                addToDiccionary(request: characterRequest, key: "Characters", completion: completionHandle)
            }
        }
    }
    func addToDiccionary<Request: FetchRequest>( request: Request, key: String, completion: @escaping (Bool) -> Void){
        
        request.execute(baseResource: type, resourceId: id, limit: 5, offset: 0).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { data in
            
            DispatchQueue.main.async {
                
                if let data = data as? ComicData {
                    self.resources[key] = data.results
                } else  if let data = data as? EventData {
                    self.resources[key] = data.results
                } else  if let data = data as? SeriesData {
                    self.resources[key] = data.results
                } else  if let data = data as? StorieData {
                    self.resources[key] = data.results
                } else  if let data = data as? CreatorData {
                    self.resources[key] = data.results
                } else  if let data = data as? CharacterData {
                    self.resources[key] = data.results
                }
                completion(true)
            }
        }.store(in: &cancellables)
    }
}
