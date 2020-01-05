//
//  QIApiModel.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//


//static var itemId = "21650243f4e08314afd3"

import Foundation
enum QIApiType:String
{
    case items = "items"
    case comment = "comment"
}

public protocol QIApiRequest{
    associatedtype Response: Codable
    var apiKey:String{ get }
    var baseURL:String { get }
    func respons(data:Data) -> Response
}

extension QIApiRequest{
    var apiKey:String { return "2d8531554550f8d0fd7c2f8d76fb25e10fb2f5a7"}
    var baseURL:String { return "https://qiita.com/api/v2"}
}

