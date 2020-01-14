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
    func failed()
}
//API呼ぶ処理を定義、interactorInput経由データをやり取り
class QIItemInteractor:QIItemInteractorInput,QIApiRequest
{
    typealias Response = QIItemEntity
    var output:QIItemInteractorOutput!
    
    //記事を取得
    func fetchItem(itemId: String)
    {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId

        log.info(baseUrl)
        AF.request(baseUrl).responseJSON { (res) in
            let response = try! JSONDecoder().decode(Response.self, from: res.data!)
            log.info(response)

            self.output.fetchedItem(item: response)
        }
        
        
    }
    
    func fetchComment(itemId: String) {
        let baseUrl = baseURL + QIApiType.comment.rawValue + "/" + itemId
    
        AF.request(baseUrl).responseJSON { (res) in
           
            log.info(res)
            
        }
    }
    
    
}
