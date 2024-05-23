//
//  FetchMockResources.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 23/5/24.
//

import Foundation

class FetchMockResources {
    
    func execute<T: Decodable>(for name: String, with type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            return nil
        }
        guard let dataMock = try? Data(contentsOf: url) else {
            return nil
        }
        guard let response = try? JSONDecoder().decode(type.self, from: dataMock) else {
            return nil
        }
        return response
    }
}
