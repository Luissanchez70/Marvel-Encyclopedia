//
//  FetchCreatorTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchCreatorTests: XCTestCase {
    
    private var sut: FetchCreator?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchCreator()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    // ID existente
    func test_execute1() throws {
        let _ = sut?.execute(baseResource: .comic, resourceId: 269, limit: 5, offset: 0).sink(receiveCompletion: { completion in
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
    // listado de todos los creadores de un comic
    func test_comparate_response_with_mock() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseCreator? = FetchMockResources().execute(for: "CreatorsMock", with: ResponseCreator.self)
        
        if let creatorDataMock = mock?.data{
            let _ = sut?.execute(baseResource: .comic, resourceId: 269, limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()

            }, receiveValue: { creatorData in
                XCTAssertEqual(creatorDataMock, creatorData)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
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
