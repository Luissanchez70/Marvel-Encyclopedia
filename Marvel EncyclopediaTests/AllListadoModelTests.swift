//
//  AllListadoModelTests.swift
//  Marvel EncyclopediaTests
//

//  Created by Diogo Filipe Abreu Rodrigues on 22/05/2024.
//

import XCTest
@testable import Marvel_Encyclopedia

final class AllListadoModelTests: XCTestCase {
    var goodModel : AllListadoModel!
    var badModel : AllListadoModel!
    
    override func setUpWithError() throws {
        goodModel = AllListadoModel(id: 1009652 , type: .character, targetTyoe: .comic)
        badModel =  AllListadoModel(id: 1009652 , type: .character, targetTyoe: .character)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        goodModel = nil
        try super.tearDownWithError()
    }
    
    func testResourcesBeforeRequestsGoodModel() throws  {
        XCTAssertEqual(goodModel.getResources().count, 0)
    }
    
    func testMoreResustsBeforeRequestsGoodModel() throws{
        XCTAssertTrue(goodModel.moreResults())
    }
    
    func testFirstRequestGoodModel () throws {
        goodModel.requestNextPage { result in
            XCTAssertTrue(result)
        }
    }
    
    func testMoreResultsAfterRequestGoodModel() throws {
        goodModel.requestNextPage { result in
            XCTAssertTrue(result)
            XCTAssertTrue(self.goodModel.moreResults())
        }
    }
    
    func testResourcesAfterRequestsGoodModel() throws  {
        goodModel.requestNextPage { result in
            XCTAssertTrue(result)
            XCTAssertEqual(self.goodModel.getResources().count, 5)
        }
    }
    
    func testMoreResustsBeforeRequestsBadModel() throws{
        XCTAssertTrue(badModel.moreResults())
    }
    
    func testFirstRequestBadModel () throws {
        badModel.requestNextPage { result in
            XCTAssertTrue(result)
        }
    }
    
    func testMoreResultsAfterRequestBadModel() throws {
        badModel.requestNextPage { result in
            XCTAssertTrue(result)
            XCTAssertFalse(self.badModel.moreResults())
        }
    }
    
    func testResourcesAfterRequestsBadModel() throws  {
        badModel.requestNextPage { result in
            XCTAssertTrue(result)
            XCTAssertEqual(self.badModel.getResources().count, 0)
        }
    }
  
}
