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
//    func fetchItem(itemId:String)
//    func fetchComment(itemId:String)
    
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
    private let disposeBag = DisposeBag()

    func fetchAllData(itemId:String)
    {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        let scheduler = OperationQueueScheduler(operationQueue: queue)
        
        //zipを使い、両方のデータが非同期で取り終わったタイミングでsubscribeし、がoutputに通知
        _ = Observable.zip(fetchItemRx(itemId: itemId), fetchCommentRx(itemId: itemId))
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (item,comments) in

                self.output?.fetchedItem(item: item)
                self.output?.fetchedComment(comments: comments)
                
            }, onError: { (_) in
                self.output?.failed()
            }, onCompleted: nil, onDisposed: nil)
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
                    self.output?.failed()
                case .success:
                    do
                    {
                        let response = try JSONDecoder().decode([QICommentEntity].self, from: res.data!)

                        ob.on(.next(response))
                        ob.on(.completed)
                    }
                    catch
                    {
                        ob.onError(error)
                    }
                }
            }
            // MARK: 失敗したら空のものを返す?
            return Disposables.create()
        }
        
    }
    
    func fetchItemRx(itemId: String)->Observable<QIItemEntity>
    {
        let baseUrl = baseURL + QIApiType.items.rawValue + "/" + itemId
        return Observable.create { (ob) -> Disposable in

            AF.request(baseUrl).responseJSON { (res) in
                
                switch res.result{
                case .failure(let error):
                    log.error(error)
                case .success:
                    do
                    {
                        let response = try JSONDecoder().decode(QIItemEntity.self, from: res.data!)

                        ob.on(.next(response))
                        ob.on(.completed)
                    }
                    catch
                    {
                        //TODO: エラー
                    }
                }
            }
            return Disposables.create()
            
        }
        
       
    }
    
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
            case .success:
                do
                {
                    let response = try JSONDecoder().decode(QIItemEntity.self, from: res.data!)
                    log.info(response)

                }
                catch
                {
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
//                    self.output?.fetchedComment(comments: response)
                    
                    
                }
                catch
                {
                    self.output?.failed()
                }
                
            }
            
        }
    }
    
    
}
