//
//  FetchCreatorTest.swift
//  Marvel EncyclopediaTests
//
//  Created by Sonia Ujaque Ortiz on 27/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchCreatorTest: XCTestCase {
    private var sut: FetchCreator?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchCreator()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    
    func test_fetchCreator() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock = FetchMockResources().execute(for: "CreatorsMock", with: ResponseCreator.self)
        if let mockData = mock?.data {
            sut?.execute(baseResource: .comic, resourceId: 269, limit: 5, offset: 0)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true)
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                    expectation.fulfill()
                }, receiveValue: { creatorData in
                    XCTAssertEqual(mockData, creatorData)
                    expectation.fulfill()
                }).store(in: &cancellable)
        } else {
            XCTFail("Mock no valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
   

}

extension CreatorData: Equatable {
    public static func == (lhs: CreatorData, rhs: CreatorData) -> Bool {
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Creator: Equatable {
    public static func == (lhs: Creator, rhs: Creator) -> Bool {
        return lhs.id == rhs.id &&
        lhs.firstName == rhs.firstName &&
        lhs.middleName == rhs.middleName &&
        lhs.lastName == rhs.lastName
    }
}
