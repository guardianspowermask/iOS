//
//  FeedbackVO.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/16.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct FeedbackVO: Codable {
    let message: String?
    let data: Feedback?
}

struct Feedback: Codable {
    let img: String?
    let date: String?
}
