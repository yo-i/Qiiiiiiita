//
//  QICommentInteractorTests.swift
//  QiiiiiiitaTests
//
//  Created by 楊 逸帆 on 2020/02/07.
//  Copyright © 2020 yo_i. All rights reserved.
//

import XCTest
import RxSwift
@testable import Qiiiiiiita

class QICommentInteractorTests: XCTestCase {

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

    func testPostCommentSuccess(){
        let interactor = QICommentInteractor()
        let output = MockCommentInteractorOutput()
        let api = MockCommentService()
        interactor.output = output
        interactor.api = api
        let apiExpectaion = self.expectation(description: "postComment")
        output.expectation = apiExpectaion
        interactor.postComment(itemId: "success_case_id", comment: "success_comment")
        wait(for: [apiExpectaion], timeout: 5)
        XCTAssertTrue(output.isCallPostedComment)
        XCTAssertFalse(output.isCalledFailed)
    }

    func testPostCommentFailed(){
        let interactor = QICommentInteractor()
        let output = MockCommentInteractorOutput()
        let api = MockCommentService()
        interactor.output = output
        interactor.api = api
        api.apiError = QICommentInteractorError.json
        let apiExpectaion = self.expectation(description: "postComment")
        output.expectation = apiExpectaion
        interactor.postComment(itemId: "failed_case_id", comment: "failed_comment")
        wait(for: [apiExpectaion], timeout: 5)
        XCTAssertTrue(output.isCalledFailed)
        XCTAssertFalse(output.isCallPostedComment)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    class MockCommentInteractorOutput: QICommentInteractorOutput {
        var expectation:XCTestExpectation?

        var isCallPostedComment = false
        func postedComment() {
            isCallPostedComment = true
            expectation?.fulfill()
        }
        
        var isCalledFailed = false
        func failed() {
            isCalledFailed = true
            expectation?.fulfill()

        }
    }

    class MockCommentService:QICommentService{
        var apiError: QICommentInteractorError?
        override func postCommentRx(itemId: String, comment: String) -> Observable<Bool> {
            return Observable.create { (ob) -> Disposable in
                if let error = self.apiError {
                    ob.on(.error(error.error()))
                }
                else
                {
                    ob.on(.next(true))
                }
                return Disposables.create()
            }
        }
    }
}
