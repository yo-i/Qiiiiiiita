//
//  QIItemViewInteractor.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol QIItemInteractorInput {
    func fetchAllData(itemId:String)
}

protocol QIItemInteractorOutput {
    func fetchedItem(item:QIItemEntity)
    func fetchedComment(comments:[QICommentEntity])
    func failed()
    func success()
}

let QIItemErrorDomin = "QIItemInteractor"
enum QIItemInteractorError:Int
{
    case fatchItem
    case fatchComment
    case json
    
    func error(userInfo: [String : AnyObject]? = nil) -> NSError {
        return NSError(domain: QIItemErrorDomin, code: self.rawValue, userInfo: userInfo)
    }
}


internal class QIItemService:QIApiRequest
{
    func fetchItemRx(itemId: String)->Observable<QIItemEntity>
    {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId
        log.info(baseUrl)
        return Observable.create { (ob) -> Disposable in

            AF.request(baseUrl).responseJSON { (res) in
                
                switch res.result{
                case .failure(let error):
                    log.error(error)
                    ob.on(.error(QIItemInteractorError.fatchItem.error()))
                case .success:
                    do
                    {
                        let response = try JSONDecoder().decode(QIItemEntity.self, from: res.data!)

                        ob.on(.next(response))
                        ob.on(.completed)
                    }
                    catch
                    {
                        ob.on(.error(QIItemInteractorError.json.error()))
                    }
                }
            }
            return Disposables.create()
            
        }
    }
    
    func fetchCommentRx(itemId: String)->Observable<[QICommentEntity]>
    {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId + "/" + QIApiType.comment.rawValue
        log.info(baseUrl)
        return Observable.create { (ob) -> Disposable in
            AF.request(baseUrl).responseJSON { (res) in
                switch res.result{
                case .failure(let error):
                    log.error(error)
                    ob.on(.error(QIItemInteractorError.fatchComment.error()))
                case .success:
                    do
                    {
                        let response = try JSONDecoder().decode([QICommentEntity].self, from: res.data!)

                        ob.on(.next(response))
                        ob.on(.completed)
                    }
                    catch
                    {
                        ob.on(.error(QIItemInteractorError.json.error()))
                    }
                }
            }
            return Disposables.create()
        }
        
    }
}

//API呼ぶ処理を定義、interactorInput経由データをやり取り
class QIItemInteractor:QIItemInteractorInput
{
    var api = QIItemService()
    var output:QIItemInteractorOutput?
    private let disposeBag = DisposeBag()

    func fetchAllData(itemId:String)
    {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        let scheduler = OperationQueueScheduler(operationQueue: queue)

        //zipを使い、両方のデータが非同期で取り終わったタイミングでsubscribeし、がoutputに通知
        _ = Observable.zip(api.fetchItemRx(itemId: itemId), api.fetchCommentRx(itemId: itemId))
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (item,comments) in

                self.output?.fetchedItem(item: item)
                self.output?.fetchedComment(comments: comments)
                self.output?.success()
            }, onError: { (_) in
                self.output?.failed()
            }, onCompleted: nil, onDisposed: nil)
    }

}
