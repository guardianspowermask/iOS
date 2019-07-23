//
//  NibLoadable.swift
//  KoreanGuardians
//
//  Created by 강수진 on 23/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

protocol NibLoadable: class {
    static var nibId: String { get }
}

extension NibLoadable {
    static var nibId: String {
        return String(describing: self)
    }
    var nidId: String {
        return String(describing: type(of: self))
    }
}
