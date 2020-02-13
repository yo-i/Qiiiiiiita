//
//  QIDefine.swift
//  Qiiiiiiita
//
//  Created by yo_i on 2020/01/17.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
import XCGLogger
let log = XCGLogger.default

/// メッセージの文言を整理する
/// メッセージの文言増え場合、ここに追加
enum QIMessage:String
{
    case noNetwork  = "ネットワーク接続が検出されませんでした。"
    case item   = "記事の取得"
    case comment = "コメント投稿"
    
    func success(forceMessage:String? = nil)->String
    {
        //文脈がおかしいの場合、caseで別ける
        switch self{

        default:
            guard let forceMsg = forceMessage else {
                return self.rawValue + "に成功しました。"
            }
            return self.rawValue + forceMsg
        }
        
    }
    
    func error()->String
    {
        return self.rawValue + "に失敗しました。"
    }
    
    func doing()->String
    {
        return self.rawValue + "中..."
    }
    
}
