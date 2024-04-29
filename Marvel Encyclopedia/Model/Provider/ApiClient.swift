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
    private let apiIdentification:String
    private let urlSession: URLSession
    
    init() {
        apiIdentification = "ts=1&\(publicKey)&\(hash)"
        urlSession = URLSession.shared
    }
    
    func getMarvelCharacter() -> AnyPublisher<[MarvelCharacter], Error> {
        let endpoint = "\(urlBase)characters?\(apiIdentification)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return responseCharacters(url)
    }
    
    func getMarvelCharacter(whereClause: String) -> AnyPublisher<[MarvelCharacter], Error> {
        let endpoint = "\(urlBase)characters?\(whereClause)&\(apiIdentification)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return responseCharacters(url)
    }
    
    func responseCharacters(_ url: URL) -> AnyPublisher<[MarvelCharacter], Publishers.Map<Publishers.Decode<Publishers.MapKeyPath<URLSession.DataTaskPublisher, JSONDecoder.Input>, ResponseCharacter, JSONDecoder>, [MarvelCharacter]>.Failure> {
        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseCharacter.self, decoder: JSONDecoder())
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(urlBase: String, complition: @escaping (UIImage?) -> () ) {
        
        let endPoint: String = "\(urlBase)?ts=1&\(publicKey)&\(hash)"
        return connectionApi(endpoint: endPoint) { data in
            guard let image: UIImage = UIImage(data: data) else { return }
            complition(image)
        }
    }
}

//MARK: - Requests to stories
extension ApiClient {
    
    func connectionApi(endpoint: String, complition: @escaping (Foundation.Data) -> ()) {
        
        guard let url = URL(string: endpoint) else { return }
        urlSession.dataTask(with: url) {data, response, error in
            if (200...299).contains((response as! HTTPURLResponse).statusCode) {
                guard let data = data else { return }
                 complition(data)
            }
        }.resume()
    }
    
    func getStories( endPoint : String , complition: @escaping (ResponseStorie?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseStorie = try! JSONDecoder().decode(ResponseStorie.self, from: data)
            complition(apiResponse)
        }
    }
    
    func getStories(characterId: Int,limit : Int = 5, complition: @escaping (ResponseStorie?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/stories?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getStories(endPoint: endPoint, complition: complition)
    }
    
    func getStories(comicId: Int,limit : Int = 5, complition: @escaping (ResponseStorie?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/comics/\(comicId)/stories?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getStories(endPoint: endPoint, complition: complition)
    }

//MARK: - requests to comics

    func getComics( endPoint : String , complition: @escaping (ResponseComic?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseComic = try! JSONDecoder().decode(ResponseComic.self, from: data)
            complition(apiResponse)
        }
    }
    
    func getComics(characterId: Int, limit : Int = 5, complition: @escaping (ResponseComic?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/comics?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getComics(endPoint: endPoint, complition: complition)
    }

//MARK: - requests to Series

    func getSeries( endPoint : String , complition: @escaping (ResponseSeries?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseSeries = try! JSONDecoder().decode(ResponseSeries.self, from: data)
            complition(apiResponse)
        }
    }
    func getSeries(characterId: Int,limit : Int = 5, complition: @escaping (ResponseSeries?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/series?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getSeries(endPoint: endPoint, complition: complition)
    }

//MARK: - Request to events

    func getEvents( endPoint : String , complition: @escaping (ResponseEvent?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseEvent = try! JSONDecoder().decode(ResponseEvent.self, from: data)
            complition(apiResponse)
        }
    }
    
    func getEvents(characterId: Int,limit : Int = 5, complition: @escaping (ResponseEvent?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/events?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getEvents(endPoint: endPoint, complition: complition)
    }
    
    func getEvents(comicId: Int,limit : Int = 5, complition: @escaping (ResponseEvent?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/comics/\(comicId)/events?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getEvents(endPoint: endPoint, complition: complition)
    }
    
//MARK: - Request to characters

    func getCharacters( endPoint : String , complition: @escaping (ResponseCharacter?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseCharacter = try! JSONDecoder().decode(ResponseCharacter.self, from: data)
            complition(apiResponse)
        }
    }
    func getCharacters(comicId: Int,limit : Int = 5, complition: @escaping (ResponseCharacter?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/comics/\(comicId)/characters?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getCharacters(endPoint: endPoint, complition: complition)
    }
    
    func getCharacters(urlBase: String, complition: @escaping (ResponseCharacter?)  -> () ) throws {
        let endPoint: String = "\(urlBase)ts=1&\(publicKey)&\(hash)"
        return try getCharacters(endPoint: endPoint, complition: complition)
    }
    
//MARK: - Request to creators
    
    func getCreators( endPoint : String , complition: @escaping (ResponseCreator?)  -> () ) throws {
        return connectionApi(endpoint: endPoint) { data in
            let apiResponse: ResponseCreator = try! JSONDecoder().decode(ResponseCreator.self, from: data)
            complition(apiResponse)
        }
    }
    func getCreators(comicId: Int, limit : Int = 5, complition: @escaping (ResponseCreator?)  -> () ) throws {
        let endPoint: String = "https://gateway.marvel.com/v1/public/comics/\(comicId)/creators?limit=\(limit)&ts=1&\(publicKey)&\(hash)"
        return try getCreators(endPoint: endPoint, complition: complition)
    }
}

