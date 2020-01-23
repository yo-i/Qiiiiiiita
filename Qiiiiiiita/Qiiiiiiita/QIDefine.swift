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

    
    func success()->String
    {
        //文脈がおかしいの場合、caseで別ける
        switch self{

        default:
            return self.rawValue + "が完了しました。"
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
