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
    private let disposeBag = DisposeBag()
    
    
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
        presenter.getAllData(itemId: QIItemId)
    }
    
    //
    func setupView()
    {
        self.itemTable.delegate = self
        self.itemTable.dataSource = self
        self.itemTable.register(UINib(nibName: "QIItemCell", bundle: nil), forCellReuseIdentifier: "QIItemCell")
        self.itemTable.register(UINib(nibName: "QICommentCell", bundle: nil), forCellReuseIdentifier: "QICommentCell")
        
    }
    func setupRx()
    {
        //NOP
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
        self.itemTable.reloadSections(IndexSet(integer: 0), with: .automatic)
        self.navigationItem.title = item.title
        
    }
    
    func showComments(comment: [QICommentEntity]) {
        self.comments = comment.sorted(by: { (e1, e2) -> Bool in
            e1.createdAt < e2.createdAt
        })
        self.itemTable.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    func showNetWorkError() {
     
        self.view.makeToast(QIMessage.item.error())
        
    }
}

extension QIItemViewController:UITableViewDataSource,UITableViewDelegate
{
 
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0://投稿内容
            return UIView()
        default://コメント内容
            if self.comments.count > 0
            {
                return Bundle.main.loadNibNamed("QIItemHeader", owner: self, options: nil)?.first as? UIView
            }
            else
            {
                return nil
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //2固定
    }
    
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "QIItemCell") as! QIItemCell
                self.presenter.tableSetItemCell(item: toPresentItem, cell: cell)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "QICommentCell") as! QICommentCell
                self.presenter.tableSetCommentCell(comment: self.comments[indexPath.row], cell: cell)
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    
}
