//
//  CategoryVO.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct CategoryVO: Codable {
    let message: String
    let data: [Category]
}

struct Category: Codable {
    let categoryIdx: Int
    let name: String
    let itemCnt: Int
    let img: String
    let replaceWords: [String]
    enum CodingKeys: String, CodingKey {
        case categoryIdx = "category_idx"
        case name
        case itemCnt = "item_cnt"
        case img
        case replaceWords = "replace_words"
    }
}
