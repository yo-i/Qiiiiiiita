//
//  QIItemViewPresenter.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import RxSwift


protocol QIItemViewPresenter {
    func getItem(itemId:String)
    func getComments(itemId:String)
    func didClickCommentButton(item:QIItemEntity)
    func viewDidLoad()
    func viewDidAppear()
    func tableSetItemCell(item:QIItemEntity,cell:QIItemCell)
    func tableSetCommentCell(comment:QICommentEntity,cell:QICommentCell)
}

class QIItemViewPresentation:QIItemViewPresenter,QIItemInteractorOutput{

    weak var view:QIItemViewController?
    var router:QIItemViewRouter
    var interactor:QIItemInteractor
    
    var comments:[QICommentEntity] = []
    var item:QIItemEntity? = nil
    
    required init(view:QIItemViewController,router:QIItemViewRouter,interactor:QIItemInteractor)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    
    /// 記事取得
    /// - Parameter itemId: 記事ID
    func getItem(itemId:String)
    {
        interactor.fetchItem(itemId: itemId)
    }
    
    
    /// 記事コメント取得
    /// - Parameter itemId: 記事ID
    func getComments(itemId:String)
    {
        interactor.fetchComment(itemId: itemId)
    }
    
    
    func fetchedItem(item: QIItemEntity) {
        log.info(#function)
        self.view?.showItem(item: item)
    }
    
    func fetchedComment(comments: [QICommentEntity]) {
        log.info(#function)
        self.view?.showComments(comment: comments)
    }
    
    func didClickCommentButton(item:QIItemEntity)
    {
        self.router.pushCommentView(item: item)
    }
    
    func viewDidLoad() {
        log.info(#function)
    }

    func viewDidAppear() {
        log.info(#function)
    }
    func failed() {
        self.view?.showNetWorkError()
    }

    func tableSetItemCell(item: QIItemEntity,cell:QIItemCell) {

        cell.itemCellValue.attributedText = item.renderedBody.parseHTML2Text()

    }
    
    func tableSetCommentCell(comment: QICommentEntity,cell:QICommentCell) {

        cell.commentCellValue.attributedText = comment.renderedBody.parseHTML2Text()
    }
}
