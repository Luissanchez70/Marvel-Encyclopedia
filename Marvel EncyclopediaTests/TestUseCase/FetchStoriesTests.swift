//
//  FetchStoriesTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchStoriesTests: XCTestCase {

    private var sut: FetchStories?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchStories()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
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
        }, receiveValue: { storieData in
            XCTAssertTrue(true)
        })
    }
    
    func test_comparate_response_with_mock() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseStorie? = FetchMockResources().execute(for: "StoriesMock", with: ResponseStorie.self)
        
        if let storieDataMock = mock?.data{
            let _ = sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()

            }, receiveValue: { storieData in
                XCTAssertEqual(storieDataMock, storieData)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension StorieData: Equatable {
    public static func == (lhs: StorieData, rhs: StorieData) -> Bool {
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Storie: Equatable {
    public static func == (lhs: Storie, rhs: Storie) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}
