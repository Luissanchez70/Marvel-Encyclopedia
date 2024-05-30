//
//  URLSession+Client.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation
import Combine

public extension URLSession {
    
    func fetch<Response: Decodable> (for request: URLRequest, with type: Response.Type) -> AnyPublisher<Response, Error>
    {
        return self.dataTaskPublisher(for: request)
            .tryMap (processResponse)
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetch(for request: URLRequest) -> AnyPublisher<Data, Error> {
        return self.dataTaskPublisher(for: request)
            .tryMap (processResponse)
            .eraseToAnyPublisher()
    }
}

private extension URLSession {
    
    func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else { throw URLError(.unknown) }
        let aux = response.url!.lastPathComponent
        switch response.statusCode {
        case 400:
            throw CustomError.error400(url: aux)
        case 403:
            throw CustomError.error403(url: aux)
        case 404:
            throw CustomError.error404(url: aux)
        case 405...499:
            throw CustomError.error404(url: aux)
        case 500...599:
            throw CustomError.errorServidor(cod: response.statusCode)
        default:
            return data
        }
    }
}
enum CustomError: Error{
    case error400(url: String),
         error403(url: String),
         error404(url: String),
         errores400(url: String),
         errorServidor(cod: Int)
}
extension CustomError {
    var description: String {
        switch self {
        case .errores400(let resource):
            return "Error Client: \(resource)"
        case .error400(let resource):
            return "400 - Bad Request: \(resource)"
        case .error403(let resource):
            return "403 - Forbiden: \(resource)"
        case .error404(let resource):
            return "404 - Not Found: \(resource)"
        case .errorServidor(let cod):
            return "Error con el servidor cod: \(cod)"
        }
    }
}
