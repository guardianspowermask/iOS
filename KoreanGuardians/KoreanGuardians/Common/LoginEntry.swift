//
//  LoginEntry.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/14.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

protocol LoginEntry: UIPresentable {
    func toLoginViewController()
}

extension LoginEntry {
    func toLoginViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryboard.viewController(LoginViewController.self)
        self.viewController.present(loginVC, animated: true)
    }
}
