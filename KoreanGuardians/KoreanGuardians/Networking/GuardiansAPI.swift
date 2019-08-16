//
//  GuardiansAPI.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation
import Moya

enum GuardiansAPI {
    case getCategory
    case getItem(categoryIdx: Int, order: Int)
    case login(kakaoId: String, userName: String)
    case getComment(itemIdx: Int)
    case writeComment(itemIdx: Int, content: String)
    case getFeedback(itemIdx: Int)
    case reportComment(commentIdx: Int)
}

extension GuardiansAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "http://13.125.105.66:3000") else {
            fatalError("base url could not be configured")
        }
        return url
    }
    var path: String {
        switch self {
        case .getCategory:
            return "/category"
        case .getItem(let categoryIdx, let order):
            return "/item/\(categoryIdx)/\(order)"
        case .login:
            return "/login"
        case .getComment(let itemIdx):
            return "/comment/\(itemIdx)"
        case .writeComment:
            return "/comment"
        case .getFeedback(let itemIdx):
            return "/feedback/\(itemIdx)"
        case .reportComment:
            return "/report"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getCategory, .getItem, .getComment, .getFeedback:
            return .get
        case .login, .writeComment, .reportComment:
            return .post
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .getCategory, .getItem, .getComment, .getFeedback:
            return .requestPlain
        case .login(let kakaoId, let userName):
            let parameters: [String: Any] = ["kakao_uuid": kakaoId,
                                               "name": userName]
             return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .writeComment(let itemIdx, let content):
            let parameters: [String: Any] = ["item_idx": itemIdx,
                                               "content": content]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .reportComment(let commentIdx):
            let parameters: [String: Any] = ["user_comment_idx": commentIdx]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
