//
//  FetchStoriesTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
@testable import Marvel_Encyclopedia

final class FetchComicsTests: XCTestCase {
    
    private var sut: FetchComics?

    override func setUpWithError() throws {
        sut = FetchComics()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    // ID existente
    func test_execute1() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { comicData in
            XCTAssertNotNil(comicData)
        })
    }
    
    func test_execute2() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 1017100, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }, receiveValue: { comicData in
            
            
            XCTAssertNotNil(comicData)
        })
    }
    // ID no existente
    func test_execute3() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 5554432, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { comicData in
                XCTAssertNotNil(comicData)
            })
    }
    
    func test_execute4() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 642314, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { comicData in
                XCTAssertNotNil(comicData)
            })
    }
    
}
