//
//  DetailableObject.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import Foundation

protocol DetailableObject {
    
    var id: Int { get set }
    var name: String { get set }
    var desc: String { get set }
    var thumbnail: Thumbnail? { get set }
    
    func getName() -> String
    func getDesc() -> String
    func getThumbnail() -> Thumbnail?
    func getResources() -> [String:[Any]]
    func fetchResources( completionHandle : @escaping (Bool) -> Void )
}

extension DetailableObject {
    func getName() -> String{
        name
    }
    
    func getDesc() -> String {
        desc
    }
    
    func getThumbnail() -> Thumbnail? {
        thumbnail!
    }
}

