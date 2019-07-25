//
//  NetworkResult.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}

enum Error {
    case networkConnectFail
    case networkError(msg : String)
}
