//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit
import Combine

class DetailsViewModel {

    var detailableObject : DetailableObject
    
    var name : String
    var desc : String
    var thumbnail = PassthroughSubject<UIImage?, Never>()
    var resources = CurrentValueSubject<[String:[Any]], Never>([:])

    init(detailableObject: DetailableObject) {
        self.detailableObject = detailableObject
        name = detailableObject.getName()
        desc = detailableObject.getDesc()
    }

    func getName() -> String{
        name
    }
    
    func getDesc() -> String{
        desc
    }
    
    func fetThumbnail() {
        guard let thumbnail = detailableObject.getThumbnail() else { return }
        let base = thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        ApiClient().downloadImage(urlBase: "\(base).\(thumbnail.extension)") { image in
            DispatchQueue.main.async { [weak self] in
                self?.thumbnail.send(image)
            }
        }
    }
    
    func fetchResources() {
        detailableObject.fetchResources { success in
            if success {
                DispatchQueue.main.sync {
                    self.resources.send(self.detailableObject.getResources())
                }
            }
        }
    }
}
