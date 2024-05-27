//
//  FetchStoriesTests.swift
//  Marvel EncyclopediaTests
//
//  Created by Luis Fernando Sanchez Muñoz on 20/5/24.
//

import XCTest
import Foundation
import Combine
@testable import Marvel_Encyclopedia

final class FetchComicsTests: XCTestCase {
    
    private var sut: FetchComics?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = FetchComics()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    // ID existente
    func test_response_success() throws {
        let _ = sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }, receiveValue: { comicData in
            XCTAssertNotNil(comicData)
        }).store(in: &cancellable)
    }
    
    func test_comparate_response_with_mock() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let mock: ResponseComic? = FetchMockResources().execute(for: "ComicsMock", with: ResponseComic.self)
        
        if let comicDataMock = mock?.data{
            let _ = sut?.execute(baseResource: .character, resourceId: 1011334, limit: 5, offset: 0).sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()

            }, receiveValue: { comicData in
                print("holi")
                XCTAssertEqual(comicDataMock, comicData)
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock no es valido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension ComicData: Equatable {
    public static func == (lhs: ComicData, rhs: ComicData) -> Bool {
        
        return lhs.total == rhs.total &&
        lhs.results == rhs.results
    }
}
extension Comic: Equatable {
    public static func == (lhs: Comic, rhs: Comic) -> Bool {
        
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}
