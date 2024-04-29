//
//  DownloadImageFromAPI.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 29/4/24.
//

import Foundation
import Combine
import UIKit

class DownloadImageFromAPI: ApiClient {
    
    func execute(urlBase: String) -> AnyPublisher<UIImage?, Error> {
        let endPoint: String = "\(urlBase)?\(getApiIdentification())"
        guard let url = URL(string: endPoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
      
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError{ error in
                return Fail<Any, URLError>(error: URLError(.badURL)) as! any Error
            }
            .map{ data, response in
                return UIImage(data: data)
            }
            .eraseToAnyPublisher()
        
    }
}
