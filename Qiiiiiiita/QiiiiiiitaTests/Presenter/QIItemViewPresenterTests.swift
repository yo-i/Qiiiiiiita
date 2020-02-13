//
//  QIItemViewPresenterTests.swift
//  QiiiiiiitaTests
//
//  Created by 楊 逸帆 on 2020/02/07.
//  Copyright © 2020 yo_i. All rights reserved.
//

import XCTest
import RxSwift
@testable import Qiiiiiiita

class QIItemViewPresenterTests: XCTestCase {

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

    func testViewDidLoad(){
        let ui = MockItemInterface()
        let router = MockItemViewRouter(viewController: UIViewController())
        let interactor = MockItemInteractor()
        let presenter = QIItemViewPresentation(router: router, interactor: interactor)
        
        
        interactor.output = presenter
        presenter.userInterface = ui
        
        presenter.viewDidLoad()
        
        XCTAssertFalse(ui.isCalledShowComments)
        XCTAssertFalse(ui.isCalledShowItem)
        XCTAssertFalse(ui.isCalledShowSuccess)
        XCTAssertFalse(ui.isCalledShowNetWorkError)
        
    }
    
    func testViewDidAppear(){
        let ui = MockItemInterface()
        let router = MockItemViewRouter(viewController: UIViewController())
        let interactor = MockItemInteractor()
        let presenter = QIItemViewPresentation(router: router, interactor: interactor)


        interactor.output = presenter
        presenter.userInterface = ui

        presenter.viewDidAppear()

        XCTAssertFalse(ui.isCalledShowComments)
        XCTAssertFalse(ui.isCalledShowItem)
        XCTAssertFalse(ui.isCalledShowSuccess)
        XCTAssertFalse(ui.isCalledShowNetWorkError)
    }
    
    func testGetAllData(){
        
        let ui = MockItemInterface()
        let router = MockItemViewRouter(viewController: UIViewController())
        let interactor = MockItemInteractor()
        let presenter = QIItemViewPresentation(router: router, interactor: interactor)
        
        interactor.output = presenter
        presenter.userInterface = ui
        
        presenter.getAllData(itemId: "item_id")
     
        XCTAssertTrue(interactor.isCalledFetchAllData)
    }
    
    func testFetchedItem(){
        let ui = MockItemInterface()
        let router = MockItemViewRouter(viewController: UIViewController())
        let interactor = MockItemInteractor()
        let presenter = QIItemViewPresentation(router: router, interactor: interactor)
        
        interactor.output = presenter
        presenter.userInterface = ui
        
        presenter.fetchedItem(item: QIItemEntity())
        
        XCTAssertFalse(ui.isCalledShowComments)
        XCTAssertTrue(ui.isCalledShowItem)
        XCTAssertFalse(ui.isCalledShowSuccess)
        XCTAssertFalse(ui.isCalledShowNetWorkError)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    class MockItemViewPresenter:QIItemViewPresenter{
        var isCalledGetAllData = false
        func getAllData(itemId: String) {
            isCalledGetAllData = true
        }
        
        var isCalledDidClickCommentButton = false
        func didClickCommentButton(item: QIItemEntity) {
            isCalledDidClickCommentButton = true
        }
        
        var isCalledViewDidLoad = false
        func viewDidLoad() {
            isCalledViewDidLoad = true
        }
        
        var isCalledViewDidAppear = false
        func viewDidAppear() {
            isCalledViewDidAppear = true
        }
        
        var isCalledTableSetItemCell = false
        func tableSetItemCell(item: QIItemEntity, cell: QIItemCell) {
            isCalledTableSetItemCell = true
        }
        
        var isCallTableSetCommentCell = false
        func tableSetCommentCell(comment: QICommentEntity, cell: QICommentCell) {
            isCallTableSetCommentCell = true
        }
        
    }
    
    class MockItemViewRouter: QIItemViewRouter {
        var isCalledPushCommentView = false
        
        override func pushCommentView(item: QIItemEntity) {
            isCalledPushCommentView = true
        }
    }
    
    class MockItemInteractor :QIItemInteractor{
        
        var isCalledFetchAllData = false
        override func fetchAllData(itemId: String) {
            isCalledFetchAllData = true
        }
        
    }
    
    class MockItemInterface:QIItemViewInterface{
        
        var isCalledShowItem = false
        func showItem(item: QIItemEntity) {
            isCalledShowItem = true
        }
        
        var isCalledShowComments = false
        func showComments(comment: [QICommentEntity]) {
            isCalledShowComments = true
        }
        
        var isCalledShowSuccess = false
        func showSuccess() {
            isCalledShowSuccess = true
        }
        
        var isCalledShowNetWorkError = false
        func showNetWorkError() {
            isCalledShowNetWorkError = true
        }
    }


}
