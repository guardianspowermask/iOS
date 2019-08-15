//
//  ItemVO.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct ItemVO: Codable {
    let message: String
    let data: ItemData
}

struct ItemData: Codable {
    let totalCnt: Int
    let items: [Item]
    enum CodingKeys: String, CodingKey {
        case totalCnt = "total_cnt"
        case items
    }
}

struct Item: Codable {
    let itemIdx: Int
    let name, img: String
    let reportCnt: Int
    let store: String
    enum CodingKeys: String, CodingKey {
        case itemIdx = "item_idx"
        case name, img
        case reportCnt = "report_cnt"
        case store
    }
}
