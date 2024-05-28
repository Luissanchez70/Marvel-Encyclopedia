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
        switch response.statusCode {
        case 400...499:
            throw CustomError.errorCliente(cod: response.statusCode)
        case 500...599:
            throw CustomError.errorServidor(cod: response.statusCode)
        default:
            return data
        }
    }
}
enum CustomError: Error{
    case errorCliente(cod: Int), errorServidor(cod: Int)
}
extension CustomError {
    var description: String {
        switch self {
        case .errorCliente(let cod):
            return "Error con el cliente cod: \(cod)"
        case .errorServidor(let cod):
            return "Error con el servidor cod: \(cod)"
        }
    }
}
