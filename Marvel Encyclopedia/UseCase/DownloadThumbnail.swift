//
//  DownloadImageFromAPI.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 29/4/24.
//

import Foundation
import Combine
import UIKit

class DownloadThumbnail {
    
    func execute(path: String, exten: String) -> AnyPublisher<UIImage, Error> {
        let split = path.split(separator: "mg")
        let url = URLRequest(components: URLComponents(path: String(split[1]), exten: exten))
        return URLSession.shared.fetch(for: url)
            .map { data in
                return UIImage(data: data)!
            }.eraseToAnyPublisher()
    }
}
