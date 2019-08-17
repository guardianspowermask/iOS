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
    func getUserInfo(completion: @escaping ((id: String, nickName: String)?) -> Void) {
        KOSessionTask.userMeTask { (error, me) in
            if let error = error as NSError? {
                print(error)
                completion(nil)
            } else if let me = me as KOUserMe?, let id = me.id, let nickName = me.nickname {
                completion((id, nickName))
            }
        }
    }
    @IBAction func kakaoLogin(_ sender: Any) {
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            session.close()
        }
        session.open(completionHandler: { [weak self] (error) -> Void in
            guard let self = self else {
                return
            }
            if error == nil {
                if session.isOpen() {
                    self.getUserInfo(completion: { (userInfo) in
                        guard let userInfo = userInfo else {
                            return
                        }
                        print(userInfo.nickName)
                        self.login(kakaoId: userInfo.id, userName: userInfo.nickName)
                    })
                } else {
                    print("Login failed")
                }
            } else {
                print("Login error : \(String(describing: error))")
            }
            if !session.isOpen() {
                if let error = error as NSError? {
                    switch error.code {
                    case Int(KOErrorCancelled.rawValue):
                        break
                    default:
                        break
                    }
                }
            }
        })
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
