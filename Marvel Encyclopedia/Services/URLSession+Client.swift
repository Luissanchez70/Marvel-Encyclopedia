//
//  URLSession+Client.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation
import Combine

/// Tipos de errores predefinidos
enum NetworkError: Error {
    case badContent
    case invalidCode
    case notConnection
    case genericError
    case api(data: Data)
}

/// Extensión de URLSession para añadirle facilitadores que permitan hacer una consulta a traves de un URLRequest y validar los datos
public extension URLSession {
    
    /// Método que realiza una consulta con Async /await
    /// - Parameters:
    ///   - request: Petición URL de la consulta
    ///   - type: Modelo de datos al que se desea reconvertir
    /// - Throws: Errores posibles en la operación, ya sean errores en la consulta, errores en el procesamiento de la consulta, o errores en la decodificación de los datos
    /// - Returns: Modelo de datos codificado para su uso
    
    func fetch<Response: Decodable>(for request: URLRequest, with type: Response.Type) async throws -> Response {
        let (data, response) = try await self.data(for: request)
        let dataProcessed = try processResponse(data: data, response: response)
        
        return try JSONDecoder().decode(type, from: dataProcessed)
    }
    
    /// Método que realiza una consulta para Combine
    /// - Parameters:
    ///   - request: Petición URL de la consulta
    ///   - type: Modelo de datos al que se desea reconvertir
    /// - Returns: Publicador con la respuesta de la consulta
    
    func fetch<Response: Decodable>(for request: URLRequest, with type: Response.Type) -> AnyPublisher<Response, Error> {
        return self.dataTaskPublisher(for: request)
            .tryMap (processResponse)
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    

}

private extension URLSession {
    /// Método para procesar los datos de una petición URL
    /// - Parameters:
    ///   - data: datos recibidos
    ///   - response: metatados de la respuesta URL
    /// - Throws: Errores en el procesamiento:
    ///   - NetworkError.badContent: Respuesta errorea
    ///   - NetworkError.api: Cuando el status está entre 400-410
    ///   - NetworkError.invalidCode: Cuando el status es 500
    /// - Returns: Los datos si todo ha ido según los criterios de procesamiento

    func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.badContent
        }
        
        switch response.statusCode {
        case 400 ..< 410:
            throw NetworkError.api(data: data)
        case 500:
            throw NetworkError.invalidCode
        default:
            return data
        }
    }
}
