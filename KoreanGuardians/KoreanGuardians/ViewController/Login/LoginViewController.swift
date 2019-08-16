//
//  LoginViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/14.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import KakaoOpenSDK

class LoginViewController: UIViewController, NibLoadable {
    @IBOutlet weak var skipLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAttr()
    }
    func setButtonAttr() {
        let skipLoginButtonAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15),
                                                                  .foregroundColor: UIColor.lightGray,
                                                                  .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "로그인없이 이용하기",
                                                        attributes: skipLoginButtonAttr)
        skipLoginButton.setAttributedTitle(attributeString, for: .normal)
        }
    @IBAction func kakaoLogin(_ sender: Any) {
        //todo 카카오톡 로그인 구현
        let authorization = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoyLCJpYXQiOjE1NjU4OTAyMDcsImV4cCI6MTU2NzIwNDIwN30.QXCE0WjBcI197aL_ZqINdI7FzmrMYgn1vKjdkvOk9xs"
        UserData.setUserDefault(value: authorization, key: .authorization)
        self.dismiss(animated: true, completion: nil)
    } //kakao login
    @IBAction func skipLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: AlertUsable {
    func login(kakaoId: String, userName: String) {
        NetworkManager.sharedInstance.login(kakaoId: kakaoId, userName: userName) { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            switch res {
            case .success(let authorization):
                UserData.setUserDefault(value: authorization, key: .authorization)
                self.dismiss(animated: true, completion: nil)
            case .failure(let type):
                switch type {
                case .networkConnectFail:
                    self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
                case .networkError(let msg):
                    self.simpleAlert(title: "오류", message: "잠시후 다시 시도해주세요")
                    print("error log is "+msg)
                }
            }
        }
    }
}
