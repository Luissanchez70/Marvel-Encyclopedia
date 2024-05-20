//
//  FetchCharacterTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
@testable import Marvel_Encyclopedia

final class FetchCharacterTests: XCTestCase {
    
    private var sut: FetchCharacters?

    override func setUpWithError() throws {
        sut = FetchCharacters()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    // listado de todos los personajes
    func test_execute1() throws {
        let _ = sut?.execute(limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { characterData in
            XCTAssertNotNil(characterData)
        })
    }
    // listado por nombre de los personajes
    func test_execute2() throws {
        let _ = sut?.execute("3-D", limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { characterData in
            XCTAssertNotNil(characterData)
        })
    }
    // personajes de un evento
    func test_execute3() throws {
        let _ = sut?.execute(baseResource: .event, resourceId: 269, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { characterData in
                XCTAssertNotNil(characterData)
            })
    }
}
