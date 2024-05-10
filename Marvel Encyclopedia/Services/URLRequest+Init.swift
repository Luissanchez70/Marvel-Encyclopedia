//
//  URLRequest+Init.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation

extension URLRequest {
    
    init(components: URLComponents) {
        guard let url = components.url else {
            preconditionFailure("No se pudo crear la url")
        }
        self = Self(url: url)
    }
}
