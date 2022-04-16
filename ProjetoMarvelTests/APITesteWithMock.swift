//
//  ProjetoMarvelTests.swift
//  ProjetoMarvelTests
//
//  Created by c94289a on 02/12/21.
//

import XCTest
@testable import ProjetoMarvel

class ProjetoMarvelTests: XCTestCase {

    let url = "url.com"
    
    func testGetDadosWithMockRetirningError() {
        let sut = MockApiReturnigFailureEmptyDataError(url: UrlApi())
        sut.getDados(url: url) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, ApiError.emptyData)
            }
        }
    }
    
    func testGetDadosWithMockReturningOneHero() {
        let sut = MockAPI(url: UrlApi())
        sut.getDados(url: url) { result in
            if case .success(let result) = result {
                guard let response = result?.data?.results else {return}
                XCTAssertTrue(response.count > 0)
                XCTAssertEqual(response[0].name, "3-D Man")
            }
        }
    }

}
