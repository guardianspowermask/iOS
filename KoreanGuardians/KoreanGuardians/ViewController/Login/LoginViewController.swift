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
        //이전 카카오톡 세션 열려있으면 닫기
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
                    //accessToken
                    if let accessToken = session.token?.accessToken {
                        
                        UserData.setUserDefault(value: accessToken, key: .accessToken)
                        self.dismiss(animated: true, completion: nil)
                    }
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
                        //간편 로그인 취소
                        print("error : \(error.description)")
                    }
                }
            }
        })
    } //kakao login
    @IBAction func skipLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController {
    
}
