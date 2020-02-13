//
//  QIItemInteractorTests.swift
//  QiiiiiiitaTests
//
//  Created by 楊 逸帆 on 2020/02/07.
//  Copyright © 2020 yo_i. All rights reserved.
//

import XCTest
import RxSwift
@testable import Qiiiiiiita

class QIItemInteractorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchAllDataSuccess(){
        let interactor = QIItemInteractor()
        let output = MockItemInteractorOutput()
        let mockApi = MockItemService()
        interactor.api = mockApi
        interactor.output = output
        let apiExpectaion = self.expectation(description: "fetchAllData")
        output.expectation = apiExpectaion
        interactor.fetchAllData(itemId: "success_case_id")
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(output.isCalledFetchedItem)
        XCTAssertTrue(output.isCalledFetchedComment)
        XCTAssertTrue(output.isCalledSuccess)
        XCTAssertFalse(output.isCalledFailed)
    }
    
    func testFetchAllDataFailed(){
        let interactor = QIItemInteractor()
        let output = MockItemInteractorOutput()
        let mockApi = MockItemService()
        interactor.api = mockApi
        interactor.output = output
        mockApi.apiError = QIItemInteractorError.json
        let apiExpectaion = self.expectation(description: "fetchAllData")
        output.expectation = apiExpectaion
        interactor.fetchAllData(itemId: "failed_case_id")
        wait(for: [apiExpectaion], timeout: 5)
        XCTAssertFalse(output.isCalledFetchedItem)
        XCTAssertFalse(output.isCalledFetchedComment)
        XCTAssertFalse(output.isCalledSuccess)
        XCTAssertTrue(output.isCalledFailed)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    class MockItemService:QIItemService{
        var apiError: QIItemInteractorError?
        override func fetchItemRx(itemId: String) -> Observable<QIItemEntity> {
         
            return Observable.create { (ob) -> Disposable in
                if let error = self.apiError {
                    ob.on(.error(error.error()))
                }
                else
                {
                    ob.on(.next(QIItemEntity()))
                    ob.on(.completed)
                }
                return Disposables.create()
            }
        }
        
        override func fetchCommentRx(itemId: String) -> Observable<[QICommentEntity]> {
            return Observable.create { (ob) -> Disposable in
                if let error = self.apiError {
                    ob.on(.error(error.error()))
                }
                else
                {
                    ob.on(.next([]))
                    ob.on(.completed)
                }
                return Disposables.create()
            }
        }
    }
    
    class MockItemInteractorOutput:QIItemInteractorOutput{
        var expectation:XCTestExpectation?
        var isCalledFetchedItem = false
        func fetchedItem(item: QIItemEntity) {
            isCalledFetchedItem = true
        }
        
        var isCalledFetchedComment = false
        func fetchedComment(comments: [QICommentEntity]) {
            isCalledFetchedComment = true
        }
        
        var isCalledFailed = false
        func failed() {
            isCalledFailed = true
            expectation?.fulfill()
        }
        
        var isCalledSuccess = false
        func success() {
            isCalledSuccess = true
            expectation?.fulfill()
        }
        
        
    }
    
}
