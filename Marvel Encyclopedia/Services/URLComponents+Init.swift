//
//  URLComponents+Init.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation

extension URLComponents: Mapeable {
    
    private static let apikey = "bc4a5be3c71e12dfd6eb20c3f3495f7e"
    private static let hash = "aebd96392d20f5aa7027d0de97255c03"
   
    init(schema: String = "https", host: String = "gateway.marvel.com", path: String) {
        self.init()
        self.scheme = schema
        self.host = host
        self.path = "/v1/public\(path)"
        self.queryItems = [URLQueryItem(name: "ts", value: "1"),
                           URLQueryItem(name: "apikey", value: URLComponents.apikey),
                           URLQueryItem(name: "hash", value: URLComponents.hash)]
    }
    
    init(schema: String = "https", host: String = "i.annihil.us", path: String, exten: String) {
        self.init()
        self.scheme = schema
        self.host = host
        self.path = "/u/prod/marvel/i/mg\(path).\(exten)"
        self.queryItems = [URLQueryItem(name: "ts", value: "1"),
                           URLQueryItem(name: "apikey", value: URLComponents.apikey),
                           URLQueryItem(name: "hash", value: URLComponents.hash)]
    }
    
    func addParams(name: String, value: String) -> Self {
        map {
            $0.queryItems?.append(URLQueryItem(name: name, value: value))
        }
    }
}
