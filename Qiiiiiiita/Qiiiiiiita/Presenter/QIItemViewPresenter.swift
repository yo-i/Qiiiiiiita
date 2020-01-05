//
//  QIItemViewPresenter.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import RxSwift


protocol QIItemViewPresentation {
    func getItem(itemId:String)
    func getComments(itemId:String)
    func didClickCommentButton(itemId:String)
}

class QIItemViewPresenter:QIItemViewPresentation{

    weak var view:QIItemViewController?
    var router:QIItemViewRouter
    var interactor:QIItemViewInteractorInput
    
    var comments:[QICommentEntity] = []
    var item:QIItemEntity? = nil
    
    required init(view:QIItemViewController,router:QIItemViewRouter,interactor:QIItemViewInteractorInput)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    

    func getItem(itemId:String)
    {
        
    }
    
    func getComments(itemId:String)
    {
        
    }
    
    func didClickCommentButton(itemId:String)
    {
        guard let exItem = item else {
            return
        }
        self.router.pushCommentView(item: exItem)
    }
    
}
