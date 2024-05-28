//
//  FetchEventsTest.swift
//  Marvel EncyclopediaTests
//
//  Created by Sonia Ujaque Ortiz on 27/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchEventsTest: XCTestCase {
    private var sut: FetchEvents?
    private var cancelable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchEvents()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancelable = []
    }
    
    func test_fetchEvent() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock = FetchMockResources().execute(for: "EventsMock", with: ResponseEvent.self)
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
                }, receiveValue: { eventData in
                    XCTAssertEqual(mockData, eventData)
                    expectation.fulfill()
                }).store(in: &cancelable)
        } else {
            XCTFail("Mock no es válido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension EventData: Equatable {
    public static func == (lhs: EventData, rhs: EventData) -> Bool {
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}
