//
//  DetailsModelTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/05/2024.
//

import XCTest
@testable import Marvel_Encyclopedia

final class DetailsModelTests: XCTestCase {
    
    let goodResource = Comic(id: 2143,
                             title: "TestComic1",
                             description: "Test description 1",
                             thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5", extension: "jpg"))
    let goodCreator = Creator(id: 214,
                              firstName: "Diogo",
                              middleName: "Filipe",
                              lastName: "Rodrigues",
                              thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5",                    extension: "jpg"))
    let goodCharacter = Character(id: 1009652,
                                  name: "Thanos",
                                  description: "Test description 2",
                                  thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5",                    extension: "jpg"))
    let nilCreator = Creator(id: nil, firstName: nil, middleName: nil, lastName: nil, thumbnail: nil)
    let nilResource = Comic(id: nil, title: nil, description: nil, thumbnail: nil)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testNameFromGoodResource() throws {
        let sut = DetailsModel(from: goodResource, resourceTye: .comic)
        XCTAssertEqual(sut.getName() , "TestComic1")
    }
    
    func testIdFromGoodResource() throws {
        let sut = DetailsModel(from: goodResource, resourceTye: .comic)
        XCTAssertEqual(sut.getId() , 2143)
    }
    
    func testDescriptionFromGoodResource() throws {
        let sut = DetailsModel(from: goodResource, resourceTye: .comic)
        XCTAssertEqual(sut.getDesc() , "Test description 1")
    }
    
    func testTypeFromGoodResource() throws {
        let sut = DetailsModel(from: goodResource, resourceTye: .comic)
        XCTAssertEqual(sut.getType(), .comic)
    }
    
    func testThumbnailFromGoodResource() {
        let sut = DetailsModel(from: goodResource, resourceTye: .comic)
        XCTAssertEqual(sut.getThumbnail()?.path , "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5")
        XCTAssertEqual(sut.getThumbnail()?.extension, "jpg")
    }
    
    func testNameFromNilResource() throws {
        let sut = DetailsModel(from: nilResource, resourceTye: .comic)
        XCTAssertEqual(sut.getName() , "No title")
    }
    
    func testIdFromNilResource() throws {
        let sut = DetailsModel(from: nilResource, resourceTye: .comic)
        XCTAssertEqual(sut.getId() , 0)
    }
    
    func testDescriptionNilGoodResource() throws {
        let sut = DetailsModel(from: nilResource, resourceTye: .comic)
        XCTAssertEqual(sut.getDesc() , nil)
    }
    
    func testTypeFromNilResource() throws {
        let sut = DetailsModel(from: nilResource, resourceTye: .comic)
        XCTAssertEqual(sut.getType(), .comic)
    }
    
    func testThumbnailFromNildResource() throws {
        let sut = DetailsModel(from: nilResource, resourceTye: .comic)
        guard let _ = sut.getThumbnail() else {
            XCTAssertTrue(true)
            return  }
        XCTFail()
    }
    
    func testNameFromGoodCreator() throws {
        let sut = DetailsModel(from: goodCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getName() , "Diogo Rodrigues")
    }
    
    func testIdFromGoodCreator() throws {
        let sut = DetailsModel(from: goodCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getId() , 214)
    }
    
    func testDescriptionFromGoodCreator() throws {
        let sut = DetailsModel(from: goodCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getDesc() , nil)
    }
    
    func testTypeFromGoodCreator() throws {
        let sut = DetailsModel(from: goodCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getType(), .creator)
    }
    
    func testThumbnailFromGoodCreator() {
        let sut = DetailsModel(from: goodCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getThumbnail()?.path , "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5")
        XCTAssertEqual(sut.getThumbnail()?.extension, "jpg")
    }
    
    func testNameFromNilCreator() throws {
        let sut = DetailsModel(from: nilCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getName() , "No name")
    }
    
    func testIdFromNilCreator() throws {
        let sut = DetailsModel(from: nilCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getId() , 0)
    }
    
    func testDescriptionFromNilCreator() throws {
        let sut = DetailsModel(from: nilCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getDesc() , nil)
    }
    
    func testTypeFromNilCreator() throws {
        let sut = DetailsModel(from: nilCreator, resourceTye: .creator)
        XCTAssertEqual(sut.getType(), .creator)
    }
    
    func testThumbnailFromNilCreator() throws{
        let sut = DetailsModel(from: nilCreator, resourceTye: .creator)
        guard let _ = sut.getThumbnail() else {
            XCTAssertTrue(true)
            return  }
        XCTFail()
    }
    
    func testNameFromGoodCharacter() throws {
        let sut = DetailsModel(from: goodCharacter, resourceTye: .character)
        XCTAssertEqual(sut.getName() , "Thanos")
    }
    
    func testIdFromGoodCharacter() throws {
        let sut = DetailsModel(from: goodCharacter, resourceTye: .character)
        XCTAssertEqual(sut.getId() , 1009652)
    }
    
    func testDescriptionFromGoodCharacter() throws {
        let sut = DetailsModel(from: goodCharacter, resourceTye: .character)
        XCTAssertEqual(sut.getDesc() , "Test description 2")
    }
    
    func testTypeFromGoodCharacter() throws {
        let sut = DetailsModel(from: goodCharacter, resourceTye: .character)
        XCTAssertEqual(sut.getType(), .character)
    }
    
    func testThumbnailFromGoodCharacter() {
        let sut = DetailsModel(from: goodCharacter, resourceTye: .character)
        XCTAssertEqual(sut.getThumbnail()?.path , "http://i.annihil.us/u/prod/marvel/i/mg/7/70/580fe58e657e5")
        XCTAssertEqual(sut.getThumbnail()?.extension, "jpg")
    }

}
    
