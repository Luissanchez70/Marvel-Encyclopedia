//
//  FetchRequest.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 16/5/24.
//

import Foundation
import Combine

protocol FetchRequest {
    
    associatedtype DataType
    func execute (baseResource: ResourceType, resourceId: Int, limit: Int, offset: Int) -> AnyPublisher<DataType, Error>
}
