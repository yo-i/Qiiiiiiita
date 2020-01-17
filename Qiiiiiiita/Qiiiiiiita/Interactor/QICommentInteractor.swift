//
//  QICommentInteractor.swift
//  Qiiiiiiita
//
//  Created by yo_i on 2020/01/16.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import Alamofire

protocol QICommentInteractorInput {
    func postComment(itemId:String,comment:String)
}

protocol QICommentInteractorOutput {
    func postedComment()
    func failed()
}

//API呼ぶ処理を定義、interactorInput経由データをやり取り
class QICommentInteractor:QICommentInteractorInput,QIApiRequest
{
    var output:QICommentInteractorOutput?
    
    
    /// 記事にたいしてｋコメントを投稿
    /// - Parameters:
    ///   - itemId: 記事ID
    ///   - comment: コメント内容
    func postComment(itemId: String, comment: String) {
        
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId + "/comments"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey,
            "Content-Type": "application/json"
        ]
        
        let parameters:[String:String] = ["body":comment]
        
        AF.request(baseUrl, method: .post
            , parameters: parameters
            , encoder: JSONParameterEncoder.default
            , headers: headers)
            .response { (res) in
            
            switch res.result{
            case .failure(let error):
                log.error(error)
            case .success(let data):
                log.info(data)
                self.output?.postedComment()
            }
            
            
        }
        
    }
}
