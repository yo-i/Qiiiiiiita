//
//  QINewCommentViewController.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import UIKit
import Toast_Swift

protocol QINewCommentViewInterface {
    func post(itemId:String,comment:String)
    func postedComment()
    func cleanInputs()
    func showNetWorkError()
    func viewPop()
}

class QINewCommentViewController: UIViewController {

    var commentInteractor = QICommentInteractor()
    var presenter:QInewCommentViewPresentation!
    var item:QIItemEntity? = nil
    
    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        presenter = QInewCommentViewPresentation(view: self, interactor: self.commentInteractor)
        commentInteractor.output = presenter
        
        setupView()
        
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
    
    func setupView(){
     
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.lightGray.cgColor
       
        self.commentTextView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.viewGesture(sender:))))
    }
    
    @IBAction func clickPostCommetButton(_ sender: Any) {
        
        guard let haveItem = self.item else {
            return
        }
        
        guard let haveComment = self.commentTextView.text else
        {
            return
        }
        
        let lessCount = 5
        if haveComment.count < lessCount
        {
            self.view.makeToast("コメントを\(lessCount)文字以上を入力してください。")
            return
        }
        
        self.post(itemId: haveItem.id, comment: commentTextView.text)
    }
    
    //編集終了のイベントを追加
    @objc func viewGesture(sender:UITapGestureRecognizer){

        if sender.view?.isEqual(self.commentTextView) ?? false
        {
            if sender.view?.isFirstResponder ?? false
            {
                sender.view?.resignFirstResponder()
            }
            else
            {
                sender.view?.becomeFirstResponder()
            }
        }
    }
    
}


extension QINewCommentViewController:QINewCommentViewInterface{
    func cleanInputs() {
        self.commentTextView.text = String.init()
    }
    
    func post(itemId:String,comment:String) {
        self.presenter.post(comment: comment, itemId: itemId)
    }
    
    func postedComment() {
        self.view.makeToast(QIMessage.comment.success())
    }
    
    func showNetWorkError() {
         self.view.makeToast(QIMessage.comment.error())
    }
    
    func viewPop() {
        self.navigationController?.popViewController(animated: true)
    }
}
