//
//  FetchSeriesTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchSeriesTests: XCTestCase {
    
    private var sut: FetchSeries?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchSeries()
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
        }, receiveValue: { seriesData in
            XCTAssertNotNil(seriesData)
        })
    }
    
    func test_comparate_response_with_mock() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseSeries? = FetchMockResources().execute(for: "SeriesMock", with: ResponseSeries.self)
        
        if let seriesDataMock = mock?.data{
            let _ = sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()

            }, receiveValue: { seriesData in
                XCTAssertEqual(seriesDataMock, seriesData)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension SeriesData: Equatable {
    public static func == (lhs: SeriesData, rhs: SeriesData) -> Bool {
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Series: Equatable {
    public static func == (lhs: Series, rhs: Series) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}