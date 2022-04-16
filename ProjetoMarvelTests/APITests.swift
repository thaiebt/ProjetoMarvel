//
//  APITests.swift
//  ProjetoMarvelTests
//
//  Created by c94289a on 03/12/21.
//

import XCTest
@testable import ProjetoMarvel
import Accelerate

class APITests: XCTestCase {

    var sut: API!
    
    override func setUp() {
        super.setUp()
        
        self.sut = API(url: UrlApi())
    }
    
    func testCheckingGetDadosReturningTopTwentyItems() {
        let expect = expectation(description: "expect success")
        
        sut.getDados(url: sut.getURL.setUrl()) { result in
            if case .success(let result) = result {
                guard let response = result?.data?.results else {return}
                XCTAssertTrue(response.count > 0)
                XCTAssertEqual(response.count, 20)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 3.0)
    }

    func testVerificandoGetDadosReturningEmpty() {
        let expect = expectation(description: "expect success")
        let url = sut.getURL.baseURL + "/v2/public/fakecharacters?" + "ts=\(sut.getURL.ts)" + "&apikey=\(sut.getURL.publicKey)" + "&hash=\(hash)"

        sut.getDados(url: url) { result in
            if case .success(let result) = result {
                XCTAssertTrue(((result?.data?.results?.count) == nil))
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 3.0)
    }

    func testCheckingErrorDecodeData() {
        let expect = expectation(description: "expect failure")
        let url = "http://elephant-api.herokuapp.com"

        sut.getDados(url: url) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, ApiError.invalidData)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 6.0)
    }
    
    func testCheckingGetDadosReturningFirstHeroName() {
        let expect = expectation(description: "expect success")
        
        sut.getDados(url: sut.getURL.setUrl()) { result in
            if case .success(let result) = result {
                guard let response = result?.data?.results else { return }
                XCTAssertEqual(response[0].name, "3-D Man")
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 3.0)
    }
    
    func testCheckingGetDadosReturningHeroNameWithOffsetAtTwenty() {
        let expect = expectation(description: "expect success")
        
        sut.getDados(url: sut.getURL.setUrlInfiniteScroll(offset: 20, limit: 50)) { result in
            if case .success(let result) = result {
                guard let response = result?.data?.results else { return }
                XCTAssertEqual(response[0].name, "Ajak")
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 3.0)
    }
}
