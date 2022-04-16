//
//  MainViewModelTests.swift
//  ProjetoMarvelTests
//
//  Created by c94289a on 17/01/22.
//

import XCTest
@testable import ProjetoMarvel
import AVFoundation

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    let view = MockMainView()
    let api = MockAPI(url: MockUrl())
    let dataBase = MockDataBase()
    let url = MockUrl()
    
    override func setUp() {
        super.setUp()
        
        self.sut = MainViewModel(view: self.view, api: self.api, data: self.dataBase)
    }
    

    func testSearchNameReturningFromAPI() {
        sut = MainViewModel(view: MockMainView(), api: MockArrayWhenSearchHeroFromApi(url: MockUrl()), data: self.dataBase)
        sut.startSearchBarWhenIsNotEmpty(searchText: "Abyss")
        guard let hero = sut.arrayVertical[0].name else { return }
        XCTAssertEqual(2, sut.arrayVertical.count)
        XCTAssertEqual(hero, "Abyss")
    }
    
    func testSearchNameReturningEmptyFromAPI() {
        sut = MainViewModel(view: self.view, api: MockArrayWhenSearchHeroFromApiReturningEmpty(url: MockUrl()), data: self.dataBase)
        sut.startSearchBarWhenIsNotEmpty(searchText: "Banana")
        
        XCTAssertEqual(sut.arrayVertical.count, 0)
    }
    
    func testLoadindInformationFromDataBase() {
        sut.fillArrayHeroDataBase()
        
        XCTAssertEqual(sut.arrayHorizontal.count, 5)
        XCTAssertGreaterThan(sut.arrayVertical.count, 0)
    }
    
    func testSearchNameReturningFromDataBase() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureNoInternetError(url: MockUrl()), data: self.dataBase)
        sut.fillArrayHeroDataBase()
        sut.startSearchBarWhenIsNotEmpty(searchText: "Ajak")
        
        
        XCTAssert(sut.arrayVertical.count == 1)
        XCTAssertEqual(sut.arrayVertical[0].name, "Ajak")
    }
    
    func testFillArrayHeroesApiReturningFailureNoInternetError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureNoInternetError(url: MockUrl()), data: self.dataBase)
        sut.fillArrayHeroesApi()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.noInternet, apiError as! ApiError)
        XCTAssertEqual(sut.arrayHorizontal.count, 5)
        XCTAssertGreaterThan(sut.arrayVertical.count, 0)
    }
    
    func testFillArrayHeroesApiReturningFailureEmptyDataError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureEmptyDataError(url: MockUrl()), data: self.dataBase)
        sut.fillArrayHeroesApi()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.emptyData, apiError as! ApiError)
    }
    
    func testFillArrayHeroesApiReturningFailureInvalidDataError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureInvalidDataError(url: MockUrl()), data: self.dataBase)
        sut.fillArrayHeroesApi()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.invalidData, apiError as! ApiError)
    }
    
    func testRequestApiInfinitScroll() {
        sut = MainViewModel(view: self.view, api: MockApiInfinitScroll(url: MockUrl()), data: self.dataBase)
        
        sut.infiniteScroll()
        XCTAssertEqual(9, sut.arrayVertical.count)
    }
    
    func testRequestApiInfinitScrollReturningFailureNoInternetError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureNoInternetError(url: MockUrl()), data: self.dataBase)
        sut.infiniteScroll()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.noInternet, apiError as! ApiError)
    }
    
    func testRequestApiInfinitScrollReturningFailureEmptyDataError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureEmptyDataError(url: MockUrl()), data: self.dataBase)
        sut.infiniteScroll()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.emptyData, apiError as! ApiError)
    }
    
    func testRequestApiInfinitScrollReturningFailureInvalidDataError() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureInvalidDataError(url: MockUrl()), data: self.dataBase)
        sut.infiniteScroll()
        guard let apiError = sut.error else { return }
        
        XCTAssertEqual(ApiError.invalidData, apiError as! ApiError)
    }
    
    func testClearSeachText() {
        sut.fillArrayHeroesApi()
        sut.setupSearchBarWhenIsEmpty()
        
        XCTAssertEqual(5, sut.arrayHorizontal.count)
        XCTAssertEqual(4, sut.arrayVertical.count)
    }
    
    func testReloadDataVerticalAndHorizontalCollectionView() {
        sut.fillArrayHeroesApi()
        
        XCTAssertEqual(2, sut.view?.count)
    }
    
    func testShowUser() {
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureNoInternetError(url: MockUrl()), data: self.dataBase)
        sut.infiniteScroll()
        
        XCTAssertEqual(1, sut.view?.count)
    }
    
    func testLabelIsHidden() {
        sut = MainViewModel(view: self.view, api: MockArrayWhenSearchHeroFromApi(url: MockUrl()), data: self.dataBase)
        sut.startSearchBarWhenIsNotEmpty(searchText: "Abyss")
        
        XCTAssertEqual(1, sut.view?.count)
    }
    
    func testLabelIsNotHidden() {
        let expect = expectation(description: "expect success")
        sut = MainViewModel(view: self.view, api: MockApiReturnigFailureNoInternetError(url: MockUrl()), data: self.dataBase)
        sut.startSearchBarWhenIsNotEmpty(searchText: "Banana")
        
        XCTAssertEqual(1, sut.view?.count)
        expect.fulfill()
        waitForExpectations(timeout: 3.0)
    }
}



