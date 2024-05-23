//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit
import Combine

// Vista conoce a ViewModel
// ViewModel conoce a Model
// V -> VM -> M

//Modelo no conoce a el ViewModel ni a la vista
//ViewModel no conoce a la vista
// M X VM X V

class DetailsViewModel {
    
    var detailsModel: DetailsModel
    var name: String
    var desc: String?
    
    private var cancellables = Set<AnyCancellable>()
    var thumbnail = PassthroughSubject<UIImage?, Never>()
    var resources = CurrentValueSubject<[String:[Any]], Never>([:])

    init(detailsModel: DetailsModel) {
        self.detailsModel = detailsModel
        name = detailsModel.getName()
        desc = detailsModel.getDesc()
    }
    
    func getNavigationTitle() -> String {
        switch detailsModel.getType() {
        case .character:
            return "Characters: \(name)"
        case .comic:
            return "Comics: \(name)"
        case .creator:
            return "Creators: \(name)"
        case .event:
            return "Events: \(name)"
        case .serie:
            return "Series: \(name)"
        case .story:
            return "Stories: \(name)"
        }
    }

    func getName() -> String {
        name
    }
    
    func getDesc() -> String? {
        desc
    }
    
    func getID() -> Int {
        detailsModel.getId()
    }
    
    func getType() -> ResourceType {
        detailsModel.getType()
    }
    
    func fetThumbnail() {
        guard let thumbnail = detailsModel.getThumbnail() else { return }
        var base = thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        base = base + "." + thumbnail.extension
        print(base)
        DownloadThumbnail().execute(path: thumbnail.path, exten: thumbnail.extension).sink { completion in
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
        detailsModel.fetchResources { success in
            if success {
                self.resources.send(self.detailsModel.getResources())
            }
        }
    }
}
