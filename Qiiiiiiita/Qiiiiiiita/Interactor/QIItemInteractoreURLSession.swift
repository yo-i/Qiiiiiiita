//
//  QIItemInteractoreURLSession.swift
//  Qiiiiiiita
//
//  Created by yo_i on 2020/01/23.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
class QIItemInteractorURLSession:QIItemInteractorInput,QIApiRequest
{
    var output:QIItemInteractorOutput?
    let session = URLSession.shared
    
    func fetchAllData(itemId: String) {
        //TODO: URLSessionでの作成
    }
    
    func fetchItem(itemId: String) {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId
        /// URLから作られたリクエスト
        let req = URLRequest(url: URL(string: baseUrl)!)
        ///セッション通信開始
        session.dataTask(with: req, completionHandler: {
            (data,res,err) in
            
            //エラーではない場合
            if err == nil
            {
                log.error(err)
                self.output?.failed()
            }
            else
            {
                let response = try! JSONDecoder().decode(QIItemEntity.self, from: data!)
                log.info(response)

                self.output?.fetchedItem(item: response)
            }
            //セッションメモリ解放
            self.session.finishTasksAndInvalidate()
        }).resume()
        
    }
    
    func fetchComment(itemId: String) {
        let baseUrl = baseURL + QIApiType.comment.rawValue + "/" + itemId
        /// URLから作られたリクエスト
        let req = URLRequest(url: URL(string: baseUrl)!)
        ///セッション通信開始
        session.dataTask(with: req, completionHandler: {
            (data,res,err) in
            
            //エラーではない場合
            if err == nil
            {
                log.error(err)
                self.output?.failed()
            }
            else
            {
                let response = try! JSONDecoder().decode([QICommentEntity].self, from: data!)
                log.info(response)

                self.output?.fetchedComment(comments: [])
            }
            //セッションメモリ解放
            self.session.finishTasksAndInvalidate()
        }).resume()
    }
}
