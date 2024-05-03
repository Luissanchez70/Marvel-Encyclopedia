//
//  FetchAnyByAnyID.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import Foundation
import Combine

class FetchAnyByAnyIDList: ApiClient {
    func execute(baseResource : String, baseID: Int, targetResource : String, limit : Int = 5) -> AnyPublisher<Data, URLError> {
        let endpoint = "\(getUrlBase())\(baseResource)/\(baseID)/\(targetResource)?limit=\(limit)&\(getApiIdentification())"
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return getUrlSession().dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
     
}
