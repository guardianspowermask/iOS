//
//  GuardiansAPI.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation
import Moya

enum JungnamiAPI  {
    case getCategory
    case getItem(categoryIdx: Int, order: Int)
}

extension JungnamiAPI : TargetType{
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
        @unknown default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategory, .getItem:
            return .get
        @unknown default:
            return .get
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
        case .getCategory, .getItem:
            return .requestPlain
        @unknown default:
            return .requestPlain
        }
    }
    var validationType : ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}
