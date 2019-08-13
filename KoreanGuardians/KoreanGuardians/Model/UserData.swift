//
//  UserData.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/14.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

enum UserDataKey: String {
    case accessToken = "accessToken"
}

struct UserData {
    static func setUserDefault(value: Any, key: UserDataKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    static func getUserDefault<T>(key: UserDataKey, type: T.Type) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    static var isUserLogin: Bool {
        if UserData.getUserDefault(key: .accessToken, type: String.self) == nil {
            return false
        } else {
            return true
        }
    }
}
