//
//  CommentVO.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/16.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct CommentVO: Codable {
    let message: String?
    let data: [Comment]?
}

struct Comment: Codable {
    let userCommentIdx: Int?
    let name: String?
    let itemIdx, userIdx: Int?
    let content, date: String?
    enum CodingKeys: String, CodingKey {
        case userCommentIdx = "user_comment_idx"
        case name
        case itemIdx = "item_idx"
        case userIdx = "user_idx"
        case content, date
    }
}
