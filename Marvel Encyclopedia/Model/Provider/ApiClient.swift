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
    
    func executeApi(urlBase: String, complition: @escaping (ResponseCharacter?)  -> () ) throws {
        
        let endPoint: String = "\(urlBase)ts=1&\(publicKey)&\(hash)"
        guard let url = URL(string: endPoint) else { return }
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error -------> \(error.localizedDescription)")
            }
           if (200...299).contains((response as! HTTPURLResponse).statusCode) {
               if let data = data {
                   let apiResponse: ResponseCharacter = try! JSONDecoder().decode(ResponseCharacter.self, from: data)
                   complition(apiResponse)
               }
            }
        }.resume()
    }
    
    func downloadImage(urlBase: String, complition: @escaping (UIImage?) -> () ) {
        let endPoint: String = "\(urlBase)?ts=1&\(publicKey)&\(hash)"
        guard let url = URL(string: endPoint) else { return }
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error -------> \(error.localizedDescription)")
            }
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                if let data = data {
                    guard let image: UIImage = UIImage(data: data) else { return }
                    complition(image)
                }
             }
        }.resume()
    }
    
<<<<<<< Updated upstream
    func fetchComics(ByCharacterId id : Int ) async throws -> ResponseComic? {
        var apiResponse: ResponseComic? = nil
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(id)/comics?ts=1&\(publicKey)&\(hash)"
=======
    func fetchComics(_ endPoint : String) async throws -> ResponseComic?  {
        print(endPoint)
        var apiResponse: ResponseComic? = nil
        if let url = URL(string: endPoint) {
            print(1)
            let (data, response) = try await URLSession.shared.data(from: url)
            let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted

                    print(String(data: data, encoding: .utf8)!)   //print to console
              
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                print(2)
                apiResponse = try JSONDecoder().decode(ResponseComic.self, from: data)
                print(3)
            }
        }
        
        print(4)
        return apiResponse
    }
    
    func fetchComics(ByCharacterId id : Int ) async throws -> ResponseComic? {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(id)/comics?ts=1&\(publicKey)&\(hash)"
        return try await fetchComics(endPoint)
    }
    
    func fetchSeries(_ endPoint : String) async throws -> ResponseSeries? {
        var apiResponse: ResponseSeries? = nil
>>>>>>> Stashed changes
        if let url = URL(string: endPoint) {
            let (data, response) = try await URLSession.shared.data(from: url)
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                apiResponse = try JSONDecoder().decode(ResponseSeries.self, from: data)
            }
        }
        return apiResponse
    }
    
    func fetchSeries(ByCharacterId id : Int )  async throws -> ResponseSeries? {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(id)/series?ts=1&\(publicKey)&\(hash)"
        return try await fetchSeries(endPoint)
    }
}
