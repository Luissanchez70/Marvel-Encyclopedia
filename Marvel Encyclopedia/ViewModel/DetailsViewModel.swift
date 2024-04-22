//
//  DetailsViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/04/2024.
//

import UIKit

protocol DetailableObject {
    func getName() -> String
    func getDesc() -> String
    func getThumbnail() -> String
    func getRessources() -> [Any]
    func fetchResources( completionHandle : @escaping (Bool) -> Void )
}

class DetailsViewModel {
    
    @Published var name : String?
    @Published var desc : String?
    @Published var thumbnail : String?
    @Published var resources : [Any]?
    
    var detailableObject : DetailableObject
    
    init(detailableObject: DetailableObject) {
        self.detailableObject = detailableObject
        name = detailableObject.getName()
        desc = detailableObject.getDesc()
    }
    
    func getResources() {
        detailableObject.fetchResources { sucess in
            if sucess {
                self.updateResources()
            }
        }
    }
    
    private func updateResources() {
        resources = detailableObject.getRessources()
    }
    
}
