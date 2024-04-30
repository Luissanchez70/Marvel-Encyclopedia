//
//  URLRequest+Init.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation

/// Extensión de URLRequest para añadirle un constructor personalizado y la posibilidad de crear una request por composición
/// El protocolo Mapeable, facilita la creación de una nueva estructura a partir de la original para crear una copia modificada.
extension URLRequest: Mapeable {
    
    /// Constructor personalizado
    /// - Parameter components: Componentes de la URL, existe una extensión para facilitar la creación
    init(components: URLComponents) {
        guard let url = components.url else {
            preconditionFailure("Unable to get URL from URLComponents: \(components)")
        }
        
        self = Self(url: url)
    }
    
    /// Función para transformar una URLRequest y añadirle el método de consutla
    /// - Parameter httpMethod: Método de consulta de la Request (GET, POST, ...)
    /// - Returns: Devuelve la propia URLRequest transformada
    func add(httpMethod: HTTPMethod) -> Self {
        map { $0.httpMethod = httpMethod.rawValue }
    }
    
    /// Función para transformar una URLRequest y añadirle cabeceras
    /// - Parameter headers: Listado de cabeceras que se le desean añadir
    /// - Returns: Devuelve la propia URLRequest transformada
    func add(headers: [String: String]) -> Self {
        map {
            let allHTTPHeaderFields = $0.allHTTPHeaderFields ?? [:]
            let updatedAllHTTPHeaderFields = headers
                .reduce(into: [String: String]()) { dict, tuple in
                    dict.updateValue(tuple.1, forKey: tuple.0)
                }
            
            $0.allHTTPHeaderFields = allHTTPHeaderFields.merging(updatedAllHTTPHeaderFields, uniquingKeysWith: { $1 })
        }
    }
    
    /// Función para transformar una URL Request y añadirle body
    /// - Parameter body: body que deseas añadir a la URL Request
    /// - Returns: Devuelve la propia URLRequest transformada
    func add<T: Encodable>(body: T) -> Self {
        map {
            guard let data = try? JSONEncoder().encode(body) else { return }
            $0.httpBody = data
        }
    }
}
    
/// Métodos de Request
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
