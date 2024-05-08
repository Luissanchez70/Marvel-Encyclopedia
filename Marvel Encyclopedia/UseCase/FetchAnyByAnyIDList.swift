//
//  FetchAnyByAnyID.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

class FetchAnyByAnyIDList: ApiClient {
    
    func execute(baseResource: ResourceType, baseID: Int, targetResource: ResourceType, limit: Int = 5, offset : Int = 0) -> AnyPublisher<Data, URLError> {
        let endpoint = "\(getUrlBase())\(baseResource.rawValue)/\(baseID)/\(targetResource.rawValue)?limit=\(limit)&offset=\(offset)&\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
