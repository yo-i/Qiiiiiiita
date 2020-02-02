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
    
    //rxで実装
    var observatAbleItem = BehaviorRelay<[QIItemEntity]>.init(value: [])
    var observatAbleComments = BehaviorRelay<[QICommentEntity]>.init(value: [])
    

    
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
        presenter.getItem(itemId: QIItemId)

        
        
    }
    
    //
    func setupView()
    {
//        self.itemTable.delegate = self
//        self.itemTable.dataSource = self
        self.itemTable.register(UINib(nibName: "QIItemCell", bundle: nil), forCellReuseIdentifier: "QIItemCell")
        self.itemTable.register(UINib(nibName: "QICommentCell", bundle: nil), forCellReuseIdentifier: "QICommentCell")
        
    }
    func setupRx()
    {
        //RXの初期化

        //TODO: sessionを分ける(entityとcell両方違う場合)
        //このままだと重複delegate
        observatAbleItem
            .filter({$0.count > 0})
            .bind(to: itemTable.rx.items(cellIdentifier: "QIItemCell", cellType: QIItemCell.self)) { row, element, cell in

                self.presenter.tableSetItemCell(item: element, cell: cell)
            }
            .disposed(by: disposeBag)
        
        
        
//        observatAbleComments
//            .filter({$0.count > 0})
//            .bind(to: itemTable.rx.items(cellIdentifier: "QICommentCell", cellType: QICommentCell.self)) { row, element, cell in
//                self.presenter.tableSetCommentCell(comment: element, cell: cell)
//            }
//            .disposed(by: disposeBag)
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
        
        observatAbleItem.accept([item])
        
        self.presenter.getComments(itemId: item.id)
    }
    
    func showComments(comment: [QICommentEntity]) {
        self.comments = comment
        self.itemTable.reloadData()
        
        //rxデータ更新
        observatAbleComments.accept(comment)
        
    }
    
    func showNetWorkError() {
     
        self.view.makeToast(QIMessage.item.error())
        
    }
}

//extension QIItemViewController:UITableViewDelegate
//{
//    
//}
//
//extension QIItemViewController:UITableViewDataSource
//{
// 
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0://投稿内容
//            return itemCount
//        default://コメント内容
//            return self.comments.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        switch indexPath.section{
//            case 0:
//                guard let toPresentItem = self.item else
//                {
//                    return UITableViewCell()
//                }
//                let cell = tableView.dequeueReusableCell(withIdentifier: "QIItemCell") as! QIItemCell
//                self.presenter.tableSetItemCell(item: toPresentItem, cell: cell)
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "QICommentCell") as! QICommentCell
//                self.presenter.tableSetCommentCell(comment: self.comments[indexPath.row], cell: cell)
//                return cell
//            default:
//                return UITableViewCell()
//        }
//    }
//    
//    
//}
