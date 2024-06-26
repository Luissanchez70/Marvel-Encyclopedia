//
//  ApiClient.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import Foundation
import Combine
import UIKit

class ApiClient {
    
    private let urlBase: String = "https://gateway.marvel.com/v1/public/"
    private let publicKey: String = "apikey=bc4a5be3c71e12dfd6eb20c3f3495f7e"
    private let hash: String = "hash=aebd96392d20f5aa7027d0de97255c03"
    private let apiIdentification: String
    private let urlSession: URLSession
    
    init() {
        apiIdentification = "ts=1&\(publicKey)&\(hash)"
        urlSession = URLSession.shared
    }
    
    func getUrlSession() -> URLSession { self.urlSession }
    func getUrlBase() -> String { self.urlBase }
    func getPublicKey() -> String { self.publicKey }
    func getHash() -> String { self.hash }
    func getApiIdentification() -> String { self.apiIdentification }
}

//MARK: - Requests to stories
extension ApiClient {
    
    func connectionApi(endpoint: String, complition: @escaping (Foundation.Data) -> ()) {
        
        guard let url = URL(string: endpoint) else { return }
        urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else { return }
             complition(data)
            
        }.resume()
    }
    
    func getStories( endPoint : String , complition: @escaping (ResponseStorie?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            do {
                let apiResponse: ResponseStorie = try JSONDecoder().decode(ResponseStorie.self, from: data)
                complition(apiResponse)
            } catch {
                complition(nil)
            }
        }
    }
}

