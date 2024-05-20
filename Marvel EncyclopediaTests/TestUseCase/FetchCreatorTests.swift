//
//  FetchCreatorTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
@testable import Marvel_Encyclopedia

final class FetchCreatorTests: XCTestCase {
    
    private var sut: FetchCreator?

    override func setUpWithError() throws {
        sut = FetchCreator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    // ID existente
    func test_execute1() throws {
        let _ = sut?.execute(baseResource: .event, resourceId: 269, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { creatorData in
            XCTAssertNotNil(creatorData)
        })
    }
    
    func test_execute2() throws {
        let _ = sut?.execute(baseResource: .event, resourceId: 296, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { creatorData in
            XCTAssertNotNil(creatorData)
        })
    }
    // ID no existente
    func test_execute3() throws {
        let _ = sut?.execute(baseResource: .event, resourceId: 111, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { creatorData in
                XCTAssertNotNil(creatorData)
            })
    }
    
    func test_execute4() throws {
        let _ = sut?.execute(baseResource: .event, resourceId: 222, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { creatorData in
                XCTAssertNotNil(creatorData)
            })
    }
    
}
