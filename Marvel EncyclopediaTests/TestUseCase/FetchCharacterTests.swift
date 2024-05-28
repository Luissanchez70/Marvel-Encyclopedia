//
//  FetchCharacterTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 27/5/24.
//

import XCTest
import Combine
@testable import Marvel_Encyclopedia

final class FetchCharacterTests: XCTestCase {
    
    private var sut: FetchCharacters?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchCharacters()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    // listado por nombre de los personajes
    func test_comparate_response_with_mock_filter_for_name() throws {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseCharacter? = FetchMockResources().execute(for: "CharacterNameMock", with: ResponseCharacter.self)
        
        if let characterDataMock = mock?.data{
            let _ = sut?.execute("Thor", limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            }, receiveValue: { characterData in
                XCTAssertEqual(characterData, characterDataMock)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    // listado de todos los personajes
    func test_comparate_response_with_mock() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseCharacter? = FetchMockResources().execute(for: "CharacterMock", with: ResponseCharacter.self)
        
        if let characterDataMock = mock?.data{
            let _ = sut?.execute(limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()

            }, receiveValue: { characterData in
                XCTAssertEqual(characterDataMock, characterData)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension CharacterData: Equatable {
    public static func == (lhs: CharacterData, rhs: CharacterData) -> Bool {
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Character: Equatable {
    public static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description
    }
}
