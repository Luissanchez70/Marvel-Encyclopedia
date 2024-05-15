//
//  ResourcesItemViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import UIKit
import Combine

protocol ResourceItem {
    var thumbnail: Thumbnail? {set get}
    var title : String? {set get}
    var description : String? {set get}
    var id : Int? {set get}
}
class ResourcesItemViewModel {
    var thumbnail = PassthroughSubject<UIImage?, Never>()
    private var cancellables = Set<AnyCancellable>()
    var thumbnailLink: Thumbnail?
    var title: String
    var desc: String
    var defaultImage: String
    
    init( from resorceItem: ResourceItem) {
        title = resorceItem.title ?? "No title"
        desc = resorceItem.description ?? "No description"
        thumbnailLink = resorceItem.thumbnail
        defaultImage = "book.fill"
    }
    
    init( from character: Character) {
        title = character.name
        desc = character.description ??  "No description"
        thumbnailLink = character.thumbnail
        defaultImage = "person.fill"
    }
    
    init( from creator: Creator) {
        title = "\(creator.firstName!) \(creator.lastName!)"
        desc = ""
        thumbnailLink = creator.thumbnail
        defaultImage = "person.fill"
    }
    
    func getThumbnail() {
        guard let thumbnailLink else {
            self.thumbnail.send(UIImage(systemName: defaultImage))
            return
        }
        let path = "\(thumbnailLink.path).\(thumbnailLink.extension)"
        let base = path.replacingOccurrences(of: "http:", with: "https:")
        DownloadThumbnail().execute(path: thumbnailLink.path, exten: thumbnailLink.extension).sink {  completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { image in
            DispatchQueue.main.async {
                self.thumbnail.send(image)
            }
        }.store(in: &cancellables)
    }
}
