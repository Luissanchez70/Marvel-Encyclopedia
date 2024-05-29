//
//  DownloadThumbnailTest.swift
//  Marvel EncyclopediaTests
//
//  Created by Sonia Ujaque Ortiz on 28/5/24.
//

import XCTest
import UIKit
import Combine
@testable import Marvel_Encyclopedia

final class DownloadThumbnailTest: XCTestCase {
    
    private var sut: DownloadThumbnail?
    private var cancellable: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = DownloadThumbnail()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellable = []
    }
    
    func test_downloadThumbnail() {
        let expectation = self.expectation(description: "Llamada asincrona")
        let image = FetchMockResources().execute()
        if image != nil {
            sut?.execute(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/514a2ed3302f5", exten: "jpg").sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true)
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                expectation.fulfill()
            }, receiveValue: { imageResponse in
                XCTAssertTrue(image?.pngData() == imageResponse.pngData())
                expectation.fulfill()
            }).store(in: &cancellable)
        } else {
            XCTFail("Mock Image no es válido")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
