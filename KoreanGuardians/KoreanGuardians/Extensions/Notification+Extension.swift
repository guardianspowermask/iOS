//
//  Notification+Extension.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/13.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

extension Notification {
    var keyboardSize: CGSize? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
    }
    var keyboardAnimationDuration: Double? {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
}
