//
//  QIItemRouter.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import UIKit

class QIItemViewRouter{
    
    weak var view:QIItemViewController?
    var newCommentVC :QINewCommentViewController?
    
    init(viewController:QIItemViewController) {
        self.view = viewController
    }
    func pushCommentView(item:QIItemEntity)
    {
        let newCommentVC = view?.storyboard?.instantiateViewController(withIdentifier: "QICommentView") as! QINewCommentViewController
        newCommentVC.item = item
        self.view?.navigationController?.pushViewController(newCommentVC, animated: true)
    }
    
}
