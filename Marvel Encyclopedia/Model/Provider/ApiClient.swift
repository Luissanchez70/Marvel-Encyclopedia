//
//  ApiClient.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import Foundation

class ApiClient {
    private let urlBase: String = "https://gateway.marvel.com/v1/public/characters"
    private let publicKey: String = "apikey=bc4a5be3c71e12dfd6eb20c3f3495f7e"
    private let hash: String = "hash=aebd96392d20f5aa7027d0de97255c03"
    
    func executeApi() async throws -> ResponseCharacter? {

        var apiResponse: ResponseCharacter? = nil
        let endPoint: String = "\(urlBase)?ts=1&\(publicKey)&\(hash)"
        
        if let url = URL(string: endPoint) {
            let (data, response) = try await URLSession.shared.data(from: url)
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                apiResponse = try JSONDecoder().decode(ResponseCharacter.self, from: data)
            }
        }
        
        return apiResponse
    }
}
