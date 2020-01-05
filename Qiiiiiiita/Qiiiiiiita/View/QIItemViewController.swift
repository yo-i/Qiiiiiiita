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

protocol QIItemViewInterface {
    func showItem(item:QIItemEntity)
    func showComments(comment:[QICommentEntity])
    func showNetWorkError()
}

class QIItemViewController: UIViewController {


    @IBOutlet weak var itemTable: UITableView!
    var presenter:QIItemViewPresentation!
    var item:QIItemEntity? = nil
    var comments:[QICommentEntity] = []
    private let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupRx()
        
        
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
        guard let existItem = self.item else {
            return
        }
        //プレゼンターに遷移するの指示を出す
        self.presenter.didClickCommentButton(itemId: existItem.id )
    }
}

extension QIItemViewController:QIItemViewInterface
{
    func showItem(item: QIItemEntity) {
        self.itemTable.reloadData()
        self.navigationController?.title = item.title
    }
    
    func showComments(comment: [QICommentEntity]) {
        self.itemTable.reloadData()
        
    }
    
    func showNetWorkError() {
        
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
            return 1
        default://コメント内容
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "comment")
        //TODO:
        return cell
    }
    
    
}
