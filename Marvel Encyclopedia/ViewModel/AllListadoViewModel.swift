//
//  AllListadoViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 08/05/2024.
//

import Combine

class AllListadoViewModel {
    
    var moreResults = true
    var totalObjects = 0
    var resource = PassthroughSubject<[Any], Never>()
    var allListadoModel : AllListadoModel
    
    init(allListModel: AllListadoModel) {
        allListadoModel = allListModel
    }
    
    func getMoreResults() -> Bool {
        return moreResults
    }
    
    func requestMoreResults() {
        allListadoModel.requestNextPage { resources,moreResulst in
            self.moreResults = moreResulst
            self.resource.send(resources)
        }
    }
}
