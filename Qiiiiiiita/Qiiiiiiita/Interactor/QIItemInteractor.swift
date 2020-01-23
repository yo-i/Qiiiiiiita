//
//  QIItemViewInteractor.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import Alamofire

protocol QIItemInteractorInput {
    func fetchItem(itemId:String)
    func fetchComment(itemId:String)
    
}

protocol QIItemInteractorOutput {
    func fetchedItem(item:QIItemEntity)
    func fetchedComment(comments:[QICommentEntity])
    func failed()
}



//API呼ぶ処理を定義、interactorInput経由データをやり取り
class QIItemInteractor:QIItemInteractorInput,QIApiRequest
{
    var output:QIItemInteractorOutput?
    
    
    /// 記事を取得
    /// - Parameter itemId: 記事のID
    func fetchItem(itemId: String)
    {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId

        log.info(baseUrl)
        AF.request(baseUrl).responseJSON { (res) in
            
            switch res.result{
            case .failure(let error):
                log.error(error)
                self.output?.failed()
            case .success:
                do
                {
                    let response = try JSONDecoder().decode(QIItemEntity.self, from: res.data!)
                    log.info(response)

                    self.output?.fetchedItem(item: response)
                    
                    //MARK: これはあり?なし?
                    //self.fetchComment(itemId: response.id)
                }
                catch
                {
                    self.output?.failed()
                }
                
            }
            
        }
        
        
    }
    
    
    /// 記事のコメントを取得
    /// - Parameter itemId: 記事ID
    func fetchComment(itemId: String) {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId + "/" + QIApiType.comment.rawValue
    
        AF.request(baseUrl).responseJSON { (res) in
           
            switch res.result{
            case .failure(let error):
                log.error(error)
                self.output?.failed()
            case .success:

                do
                {
                    //FIXME: fetchしたデータが存在しないのエラーハンドリング
                    let response = try JSONDecoder().decode([QICommentEntity].self, from: res.data!)
                    log.info(response)
                    //TODO:
                    self.output?.fetchedComment(comments: response)
                }
                catch
                {
                    self.output?.failed()
                }
                
            }
            
        }
    }
    
    
}
