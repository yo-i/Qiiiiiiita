//
//  QINewCommentViewPresenter.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/02/02.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation

protocol QINewCommentViewPresenter {
    func post(comment:String,itemId:String)
    func viewDidLoad()
    func viewDidAppear()
    func postedComment()
}

class QInewCommentViewPresentation: QINewCommentViewPresenter,QICommentInteractorOutput {

    weak var view:QINewCommentViewController?
    var interactor:QICommentInteractor
    
    
    required init(view:QINewCommentViewController,router:QIItemViewRouter? = nil,interactor:QICommentInteractor)
    {
        self.view = view
        self.interactor = interactor
    }

    
    func post(comment: String, itemId: String) {
        interactor.postComment(itemId: itemId, comment: comment)
    }
    
    func viewDidLoad() {
        //NOP
    }
    
    func viewDidAppear() {
        //NOP
    }
    
    func postedComment() {

        self.view?.postedComment()
        self.view?.cleanInputs()
    }
    
    func failed() {
        self.view?.showNetWorkError()
    }
    

}

