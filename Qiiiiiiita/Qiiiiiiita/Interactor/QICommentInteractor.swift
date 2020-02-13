//
//  QICommentInteractor.swift
//  Qiiiiiiita
//
//  Created by yo_i on 2020/01/16.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol QICommentInteractorInput {
    func postComment(itemId:String,comment:String)
}

protocol QICommentInteractorOutput {
    func postedComment()
    func failed()
}


let QICommentInteractorDomin = "QICommentInteractor"
enum QICommentInteractorError:Int
{
    case post
    case json
    func error(userInfo: [String : AnyObject]? = nil) -> NSError {
        return NSError(domain: QICommentInteractorDomin, code: self.rawValue, userInfo: userInfo)
    }
}


class QICommentService:QIApiRequest{
    /// 記事にたいしてｋコメントを投稿
    /// - Parameters:
    ///   - itemId: 記事ID
    ///   - comment: コメント内容
    func postCommentRx(itemId: String, comment: String) -> Observable<Bool>{
        
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId + "/comments"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + apiKey + "eerrr",
            "Content-Type": "application/json"
        ]
        
        let parameters:[String:String] = ["body":comment]
        
        return Observable.create { (ob) -> Disposable in
            AF.request(baseUrl, method: .post
                , parameters: parameters
                , encoder: JSONParameterEncoder.default
                , headers: headers)
                .response { (res) in
                
                switch res.result{
                case .failure(let error):
                    log.error(error)
                    ob.on(.error(QICommentInteractorError.post.error()))
                case .success(let data):
                    log.info(data)
                    
                    do{
                        let response = try JSONDecoder().decode(QICommentEntity.self, from: res.data!)
                        log.info(response)
                        ob.on(.next(true))
                        ob.on(.completed)
                    }
                    catch
                    {
                        ob.on(.error(QICommentInteractorError.json.error()))
                    }
                }
            }
            return Disposables.create()
        }
    }
}

//API呼ぶ処理を定義、interactorInput経由データをやり取り
class QICommentInteractor:QICommentInteractorInput
{    
    var output:QICommentInteractorOutput?
    var api:QICommentService?
    func postComment(itemId: String, comment: String) {
        _ = self.api?.postCommentRx(itemId: itemId, comment: comment)
            .subscribeOn(SerialDispatchQueueScheduler(qos: DispatchQoS.default))    //バックグラウンド実行
            .observeOn(MainScheduler.instance)                  //結果をメインスレッドで受け
            .subscribe(onNext: { (success) in
                if success
                {
                    self.output?.postedComment()
                }
                else
                {
                    self.output?.failed()
                }
            }, onError: { (error) in
                self.output?.failed()
            }, onCompleted: nil, onDisposed: nil)
        
    }
    
    
}
