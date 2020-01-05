//
//  QICommentEntity.swift
//  Qiiiiiiita
//
//  Created by 小鳥遊　杏 on 2020/01/05.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation
struct QICommentEntity:Codable {
    let body        :String
    let createdAt   :String
    let id          :String
    let renderedBody:String
    let updateAt    :String
    let user        :String
    
    private enum CodingKeys: String, CodingKey {
        case body
        case createdAt      = "created_at"
        case id
        case renderedBody   = "rendered_body"
        case updateAt       = "update_at"
        case user
    }
}
