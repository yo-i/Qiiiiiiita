//
//  QIItemEntity.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
//itemId:21650243f4e08314afd3
//apiKey:2d8531554550f8d0fd7c2f8d76fb25e10fb2f5a7
struct QIItemEntity:Codable {
    let renderedBody:String
    let body        :String
    let id          :String
    let title       :String
    let user        :QIUserEntity
    
    private enum CodingKeys: String, CodingKey {
        case body
        case id
        case title
        case renderedBody = "rendered_body"
        case user
    }
    
}
