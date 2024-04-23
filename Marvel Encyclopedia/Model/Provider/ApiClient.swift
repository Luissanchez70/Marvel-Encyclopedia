//
//  ApiClient.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import Foundation
import UIKit

class ApiClient {
    private let publicKey: String = "apikey=bc4a5be3c71e12dfd6eb20c3f3495f7e"
    private let hash: String = "hash=aebd96392d20f5aa7027d0de97255c03"
    private let urlSession = URLSession.shared
    
    func getCharacters(urlBase: String, complition: @escaping (ResponseCharacter?)  -> () ) throws {
        
        let endPoint: String = "\(urlBase)ts=1&\(publicKey)&\(hash)"
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseCharacter = try! JSONDecoder().decode(ResponseCharacter.self, from: data)
            complition(apiResponse)
        }
    }
    
    func downloadImage(urlBase: String, complition: @escaping (UIImage?) -> () ) {
        
        let endPoint: String = "\(urlBase)?ts=1&\(publicKey)&\(hash)"
        return connectionApi(endpoint: endPoint) { data in
            guard let image: UIImage = UIImage(data: data) else { return }
            complition(image)
        }
    }
   
    
// TODO: - Diogo mira la opcion corta que hice 
    func fetchComics(ByCharacterId id : Int ) async throws -> ResponseComic? {
        
        var apiResponse: ResponseComic? = nil
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(id)/comics?ts=1&\(publicKey)&\(hash)"
        if let url = URL(string: endPoint) {
            let (data, response) = try await URLSession.shared.data(from: url)
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                apiResponse = try JSONDecoder().decode(ResponseComic.self, from: data)
                guard let arra = apiResponse?.data.results else { return apiResponse }
                for comic in arra {
                    print("--> \(comic.id) --> \(comic.title)")
                }
            }
        }
        return apiResponse
    }
    
    func fetchSeries(_ endPoint : String) async throws -> ResponseSeries? {
        var apiResponse: ResponseSeries? = nil
        if let url = URL(string: endPoint) {
            let (data, response) = try await URLSession.shared.data(from: url)
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                let apiResponse = try JSONDecoder().decode(ResponseSeries.self, from: data)
            }
        }
        return apiResponse
    }
    
    func fetchSeries(ByCharacterId id : Int )  async throws -> ResponseSeries? {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(id)/series?ts=1&\(publicKey)&\(hash)"
        return try await fetchSeries(endPoint)
    }
    
}
// MARK: - Pruebas Luis comics
extension ApiClient {
   
    func getComics(characterId: Int, complition: @escaping (ResponseComic?)  -> () ) throws {
        
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/comics?ts=1&\(publicKey)&\(hash)"
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseComic = try! JSONDecoder().decode(ResponseComic.self, from: data)
            complition(apiResponse)
        }
    }
    func getSeries(characterId: Int, complition: @escaping (ResponseSeries?)  -> () ) throws {
        
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/series?ts=1&\(publicKey)&\(hash)"
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseSeries = try! JSONDecoder().decode(ResponseSeries.self, from: data)
            complition(apiResponse)
        }
    }
    
    func connectionApi(endpoint: String, complition: @escaping (Foundation.Data) -> ()) {
        
        guard let url = URL(string: endpoint) else { return }
        urlSession.dataTask(with: url) {data, response, error in
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                guard let data = data else { return }
                 complition(data)
            }
        }.resume()
    }
}
