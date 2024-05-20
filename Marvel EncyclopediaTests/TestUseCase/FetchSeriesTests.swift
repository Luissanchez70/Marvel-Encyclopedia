//
//  FetchSeriesTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest

@testable import Marvel_Encyclopedia

final class FetchSeriesTests: XCTestCase {
    
    private var sut: FetchSeries?

    override func setUpWithError() throws {
        sut = FetchSeries()
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
        }, receiveValue: { seriesData in
            XCTAssertNotNil(seriesData)
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
        }, receiveValue: { seriesData in
            XCTAssertNotNil(seriesData)
        })
    }
    // ID no existente
    func test_execute3() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 54123, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { seriesData in
                XCTAssertNotNil(seriesData)
            })
    }
    
    func test_execute4() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 12345, limit: 5, offset:0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
            }, receiveValue: { seriesData in
                XCTAssertNotNil(seriesData)
            })
    }
    
}
