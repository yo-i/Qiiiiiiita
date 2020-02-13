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
    func getAllData(itemId:String)
    func didClickCommentButton(item:QIItemEntity)
    func viewDidLoad()
    func viewDidAppear()
    func tableSetItemCell(item:QIItemEntity,cell:QIItemCell)
    func tableSetCommentCell(comment:QICommentEntity,cell:QICommentCell)
}

class QIItemViewPresentation:QIItemViewPresenter,QIItemInteractorOutput{

    

    weak var userInterface:QIItemViewInterface?
    var router:QIItemViewRouter
    var interactor:QIItemInteractor

    
    required init(router:QIItemViewRouter,interactor:QIItemInteractor)
    {
        self.router = router
        self.interactor = interactor
    }
    
    
    /// 記事とコメント同時取得
    /// - Parameter itemId: 記事ID
    func getAllData(itemId:String)
    {
        interactor.fetchAllData(itemId: itemId)
    }
    
    func fetchedItem(item: QIItemEntity) {
        log.info(#function)
        self.userInterface?.showItem(item: item)
    }
    
    func fetchedComment(comments: [QICommentEntity]) {
        log.info(#function)
        self.userInterface?.showComments(comment: comments)
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
    
    func success() {
        self.userInterface?.showSuccess()
    }
    
    func failed() {
        self.userInterface?.showNetWorkError()
    }
    

    func tableSetItemCell(item: QIItemEntity,cell:QIItemCell) {
        cell.itemCellValue.attributedText = item.renderedBody.parseHTML2Text()
    }
    
    func tableSetCommentCell(comment: QICommentEntity,cell:QICommentCell) {
        cell.commentCellValue.attributedText = comment.renderedBody.parseHTML2Text()
    }
}
