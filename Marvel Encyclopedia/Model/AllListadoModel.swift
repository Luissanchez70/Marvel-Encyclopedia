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
    private var type : ResourceType
    private var targetTyoe : ResourceType
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
    
    func requestNextPage(completion : @escaping ([Any] ,Bool) -> Void) {
        FetchAnyByAnyIDList().execute(baseResource: type, baseID: id, targetResource: targetTyoe, limit: limit, offset: offset+limit).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                let response = self.decodeResponse(data: data)
                self.resources.append(contentsOf: response)
                completion(self.resources, (self.offset + self.limit < self.total))
                self.offset += self.limit
            }
        }.store(in: &cancellables)
        
    }

    func decodeResponse(data: Data) -> [Any] {
        do {
            switch targetTyoe {
            case .character:
                let response = try JSONDecoder().decode(ResponseCharacter.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            case .comic:
                let response = try JSONDecoder().decode(ResponseComic.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            case .creator:
                let response = try JSONDecoder().decode(ResponseCreator.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            case .event:
                let response = try JSONDecoder().decode(ResponseEvent.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            case .serie:
                let response = try JSONDecoder().decode(ResponseSeries.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            case .story:
                let response = try JSONDecoder().decode(ResponseStorie.self, from: data).data
                offset = response.offset
                limit = response.limit
                total = response.total
                return response.results
            }
        } catch {
            print(error.localizedDescription.localizedLowercase)
        }
        return []
    }
}
