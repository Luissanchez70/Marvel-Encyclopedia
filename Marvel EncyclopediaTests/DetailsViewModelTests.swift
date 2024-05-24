//
//  DetailsViewModelTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Diogo Filipe Abreu Rodrigues on 22/05/2024.
//

import XCTest
@testable import Marvel_Encyclopedia

final class DetailsViewModelTests: XCTestCase {
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
    
    func testGetNameFromGoodResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodResource, resourceTye: .comic))
        XCTAssertEqual(sut.getName(), "TestComic1")
    }
    
    func testGetDescriptionFromGoodResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodResource, resourceTye: .comic))
        XCTAssertEqual(sut.getDesc(), "Test description 1")
    }
    
    func testGetIDFromGoodResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodResource, resourceTye: .comic))
        XCTAssertEqual(sut.getID(), 2143)
    }
    
    func testGetTypeFromGoodResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodResource, resourceTye: .comic))
        XCTAssertEqual(sut.getType(), .comic)
    }
    
    func testGetNameFromNilResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilResource, resourceTye: .comic))
        XCTAssertEqual(sut.getName(), "No title")
    }
    
    func testGetDescriptionFromNilResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilResource, resourceTye: .comic))
        XCTAssertEqual(sut.getDesc(), "No description")
    }
    
    func testGetIDFromNilResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilResource, resourceTye: .comic))
        XCTAssertEqual(sut.getID(), 0)
    }
    
    func testGetTypeFromNilResource() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilResource, resourceTye: .comic))
        XCTAssertEqual(sut.getType(), .comic)
    }
    
    func testGetNameFromGoodCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getName(), "Diogo Rodrigues")
    }
    
    func testGetDescriptionFromGoodCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getDesc(), nil)
    }
    
    func testGetIDFromGoodCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getID(), 214)
    }
    
    func testGetTypeFromGoodCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getType(), .creator)
    }
    
    func testGetNameFromNilCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getName(), nil)
    }
    
    func testGetDescriptionFromNilCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getDesc(), nil)
    }
    
    func testGetIDFromNilCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getID(), 0)
    }
    
    func testGetTypeFromNilCreator() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: nilCreator, resourceTye: .creator))
        XCTAssertEqual(sut.getType(), .creator)
    }
    
    func testGetNameFromGoodCharacter() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCharacter, resourceTye: .character))
        XCTAssertEqual(sut.getName(), "Thanos")
    }

    func testGetDescriptionFromGoodCharacter() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCharacter, resourceTye: .character))
        XCTAssertEqual(sut.getDesc(), "Test description 2")
    }
    
    func testGetIDFromGoodCharacter() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCharacter, resourceTye: .character))
        XCTAssertEqual(sut.getID(), 1009652)
    }
    
    func testGetTypeFromGoodCharacter() throws {
        let sut = DetailsViewModel(detailsModel: DetailsModel(from: goodCharacter, resourceTye: .character))
        XCTAssertEqual(sut.getType(), .character)
    }
    
}
