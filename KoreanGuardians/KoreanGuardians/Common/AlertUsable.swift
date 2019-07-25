//
//  AlertUsable.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

protocol AlertUsable: UIPresentable {
    func simpleAlert(title: String, message: String)
}

extension AlertUsable {
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let okAction = UIAlertAction(title: okTitle, style: .default)
        alert.addAction(okAction)
        self.viewController.present(alert, animated: true)
    }
}
