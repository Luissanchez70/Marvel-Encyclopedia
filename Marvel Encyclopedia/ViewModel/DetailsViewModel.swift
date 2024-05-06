//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit
import Combine

class DetailsViewModel {
    private var cancellables = Set<AnyCancellable>()
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
        var base = thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        base = base + "." + thumbnail.extension
        print(base)
        DownloadImageFromAPI().execute(urlBase: base).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { image in
            DispatchQueue.main.sync {
                self.thumbnail.send(image)
                print("echo imagen descargada")
            }
        }.store(in: &cancellables)

    }
    
    func fetchResources() {
        detailableObject.fetchResources { success in
            if success {
                self.resources.send(self.detailableObject.getResources())
            }
        }
    }
}
