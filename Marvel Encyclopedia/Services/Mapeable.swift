//
//  Mapeable.swift
//  Marvel Encyclopedia
//
//  Created by Manu García on 30/4/24.
//

import Foundation

protocol Mapeable {
    func map(_ transform: (inout Self) -> Void) -> Self
}

extension Mapeable {
    func map(_ transform: (inout Self) -> Void) -> Self {
        var request = self
        transform(&request)
        return request
    }
}
