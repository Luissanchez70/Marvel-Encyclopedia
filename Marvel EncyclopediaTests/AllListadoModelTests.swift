//
//  AllListadoModelTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/05/2024.
//

import XCTest
@testable import Marvel_Encyclopedia

final class AllListadoModelTests: XCTestCase {

    var sut : AllListadoModel!
    
    override func setUpWithError() throws {
        sut = AllListadoModel(id: 1009652, type: .character, targetTyoe: .comic)
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testOffset() throws  {
        XCTAssert(sut.moreResults())
    }
}
