//
//  FetchEventsTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
@testable import Marvel_Encyclopedia

final class FetchEventsTests: XCTestCase {
    
    private var sut: FetchEvents?

    override func setUpWithError() throws {
        sut = FetchEvents()
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
        }, receiveValue: { eventData in
            XCTAssertNotNil(eventData)
        })
    }
    
    func test_execute2() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 1017100, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { eventData in
            XCTAssertNotNil(eventData)
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
            }, receiveValue: { eventData in
                XCTAssertNotNil(eventData)
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
            }, receiveValue: { eventData in
                XCTAssertNotNil(eventData)
            })
    }
    
}
