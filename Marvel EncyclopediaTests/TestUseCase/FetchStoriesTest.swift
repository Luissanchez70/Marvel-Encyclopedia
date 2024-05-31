//
//  FetchStoriesTest.swift
//  Marvel EncyclopediaTests
//
//  Created by Sonia Ujaque Ortiz on 27/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchStoriesTest: XCTestCase {
    
    private var sut: FetchStories?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchStories()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    
    func test_fetchStories() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock = FetchMockResources().execute(for: "StoriesMock", with: ResponseStorie.self)
        if let mockData = mock?.data {
            sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true)
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                    expectation.fulfill()
                }, receiveValue: { storieData in
                    XCTAssertEqual(mockData, storieData)
                    expectation.fulfill()
                }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es válido")
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
