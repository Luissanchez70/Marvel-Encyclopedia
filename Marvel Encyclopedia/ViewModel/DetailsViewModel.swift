//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit
import Combine

protocol DetailableObject {
    func getName() -> String
    func getDesc() -> String
    func getThumbnail() -> Thumbnail
    func getResources() -> [String:[Any]]
    func fetchResources( completionHandle : @escaping (Bool) -> Void )
}

class DetailsViewModel {

    var detailableObject : DetailableObject
    
    var name : String
    var desc : String
    var thumbnail : Thumbnail
    var resources = CurrentValueSubject<[String:[Any]], Never>([:])

    init(detailableObject: DetailableObject) {
        self.detailableObject = detailableObject
        name = detailableObject.getName()
        desc = detailableObject.getDesc()
        thumbnail = detailableObject.getThumbnail()
    }
}

extension DetailsViewModel { //MARK: - Trying combine
   
    func getName() -> String{
        name
    }
    
    func getDesc() -> String{
        desc
    }
    
    func getThumbnail() -> Thumbnail {
        thumbnail
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
