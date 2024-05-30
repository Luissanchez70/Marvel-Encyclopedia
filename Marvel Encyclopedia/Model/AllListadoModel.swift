//
//  AllListadoModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 08/05/2024.
//

import Combine
import Foundation


class AllListadoModel {
    
    private var id: Int
    private var type: ResourceType
    private var targetTyoe: ResourceType
    private var resources: [Any] = []
    private var cancellables = Set<AnyCancellable>()
    private var offset = 0
    private var limit = 5
    private var total = 0
    
    init(id: Int, type: ResourceType, targetTyoe: ResourceType) {
        self.id = id
        self.type = type
        self.targetTyoe = targetTyoe
    }
    
    func requestNextPage(completion: @escaping (Bool) -> Void) {
        switch targetTyoe {
        case .comic:
            addToDiccionary(request: FetchComics(), completion: completion)
        case .event:
            addToDiccionary(request: FetchEvents(), completion: completion)
        case .serie:
            addToDiccionary(request: FetchSeries(), completion: completion)
        case .story:
            addToDiccionary(request: FetchStories(), completion: completion)
        case .creator:
            addToDiccionary(request: FetchCreator(), completion: completion)
        case .character:
            addToDiccionary(request: FetchCharacters(), completion: completion)
        }
    }

    func addToDiccionary<Request: FetchRequest>( request: Request, completion: @escaping (Bool) -> Void) {
        request.execute(baseResource: type, resourceId: id, limit: limit, offset: offset).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("\(self.type.rawValue)--> \(error.localizedDescription)")

            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                if let data = data as? ComicData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                } else  if let data = data as? EventData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                } else  if let data = data as? SeriesData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                } else  if let data = data as? StorieData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                } else  if let data = data as? CreatorData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                } else  if let data = data as? CharacterData {
                    self.resources.append(contentsOf: data.results)
                    self.total = data.total
                }
                self.offset += self.limit
                completion(true)
            }
        }.store(in: &cancellables)
    }
    
    func getResources() -> [Any] { resources }
    
    func moreResults() -> Bool {
        offset <= total
    }
}
