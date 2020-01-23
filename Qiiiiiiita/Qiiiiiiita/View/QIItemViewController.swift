//
//  QIItemViewController.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XCGLogger
import SVProgressHUD
import Toast_Swift


protocol QIItemViewInterface {
    func showItem(item:QIItemEntity)
    func showComments(comment:[QICommentEntity])
    func showNetWorkError()
}

class QIItemViewController: UIViewController {


    @IBOutlet weak var itemTable: UITableView!
    var itemInteractor = QIItemInteractor()
    var router:QIItemViewRouter!
    var presenter:QIItemViewPresentation!
    
    var item:QIItemEntity? = nil
    var comments:[QICommentEntity] = []
    
    let itemCount = 1 //記事の内容は1セルで表示
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        router = QIItemViewRouter(viewController: self)
        presenter = QIItemViewPresentation(view: self,router: router ,interactor: itemInteractor)
        itemInteractor.output = presenter
        
        setupView()
        setupRx()
        
        presenter.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
        presenter.getItem(itemId: QIItemId)

        
    }
    
    //
    func setupView()
    {
        self.itemTable.delegate = self
        self.itemTable.dataSource = self
    }
    func setupRx()
    {
        //RXの初期化
    }
    //クリックのイベント
    @IBAction func clickCommentButton(_ sender: Any) {

        guard let outPutItem = self.item else {
            return
        }
        //プレゼンターに遷移するの指示を出す
        self.presenter.didClickCommentButton(item: outPutItem )
    }
}

extension QIItemViewController:QIItemViewInterface
{
    func showItem(item: QIItemEntity) {

        self.view.makeToast(QIMessage.item.success())
        self.item = item
        self.itemTable.reloadData()
        self.navigationController?.title = item.title
        
        self.presenter.getComments(itemId: item.id)
    }
    
    func showComments(comment: [QICommentEntity]) {
        self.itemTable.reloadData()
        
    }
    
    func showNetWorkError() {
     
        self.view.makeToast(QIMessage.item.error())
        
    }
}

extension QIItemViewController:UITableViewDelegate
{
    
}

extension QIItemViewController:UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0://投稿内容
            return itemCount
        default://コメント内容
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            case 0:
                guard let toPresentItem = self.item else
                {
                    return UITableViewCell()
                }
            return self.presenter.tableSetItemCell(item: toPresentItem)
            default:
            return self.presenter.tableSetCommentCell(comment: self.comments[indexPath.row])
        }
    }
    
    
}
