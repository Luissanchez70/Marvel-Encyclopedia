//
//  ResourcesItemViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import UIKit
import Combine

class ResourcesItemViewModel {
    var thumbnail = PassthroughSubject<UIImage?, Never>()
    var thumbnailLink : Thumbnail?
    var title : String
    var desc : String
    
    init( from comic: Comic) {
        title = comic.title ?? "No title"
        desc = comic.description ?? "No description"
        thumbnailLink = comic.thumbnail
    }
    
    init( from series: Series) {
        title = series.title ?? "No title"
        desc = series.description ?? "No description"
        thumbnailLink = series.thumbnail
    }
    
    init( from storie: Storie) {
        title = storie.title ?? "No title"
        desc = storie.description ?? "No description"
        thumbnailLink = storie.thumbnail
    }
    
    init( from event : Event) {
        title = event.title ?? "No title"
        desc = event.description ?? "No description"
        thumbnailLink = event.thumbnail
    }
    
    func getThumbnail() {
        guard let thumbnailLink else { return }
        let path = "\(thumbnailLink.path).\(thumbnailLink.extension)"
        let base = path.replacingOccurrences(of: "http:", with: "https:")
        
        ApiClient().downloadImage(urlBase: base) { image in
            self.thumbnail.send(image)
        }
    }
}
