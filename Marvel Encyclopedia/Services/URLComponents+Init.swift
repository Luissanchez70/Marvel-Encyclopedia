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
    
    /// Constructor de componentes para crear una petición URL. Se añade los parámetros de api y hash de la cuenta de desarrollador de la api
    /// - Parameters:
    ///   - scheme: Protocolo de conexión con el servidor, por defecto 'https'
    ///   - host: Dominio principial del servidor, por defecto 'gateway.marvel.com'
    ///   - path: Dirección de la url a la que se desea realizar la petición. Se añade siempre '/v1/public'
    init(scheme: String = "https",
         host: String = "gateway.marvel.com",
         path: String) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = "/v1/public\(path)"
        self.queryItems = [URLQueryItem(name: "ts", value: "1"),
                                 URLQueryItem(name: "apikey", value: URLComponents.apikey),
                                 URLQueryItem(name: "hash", value: URLComponents.hash)]
    }
    
    /// Método para añadir a un URLComponents, un parámetro más a los que ya tiene definidos
    /// - Parameters:
    ///   - name: Nombre del parámetro que se añadirá
    ///   - value: Valor del parámetro que se añadirá
    /// - Returns: Nuevo URLComponents, con los datos del original y el nuevo parámetro añadido
    func newParam(name: String, value: String) -> Self {
        map {
            $0.queryItems?.append(URLQueryItem(name: name, value: value))
        }
    }
}
