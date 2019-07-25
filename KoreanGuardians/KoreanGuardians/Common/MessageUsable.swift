//
//  MessageUsable.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation
import MessageUI

protocol MessageUsable: MFMailComposeViewControllerDelegate, AlertUsable {
    func sendMail(recipents: String, subjectTitle: String, bodyTxt: String)
}

extension MessageUsable {
    func sendMail(recipents: String, subjectTitle: String, bodyTxt: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipents])
            mail.setSubject(subjectTitle)
            mail.setMessageBody(bodyTxt, isHTML: true)
            self.viewController.present(mail, animated: true)
        } else {
            let alertTitle = "실패"
            let alertMsg = "메일을 보낼 수 없습니다. 기본 메일 계정 설정이 되어있는지 확인해주세요."
            self.simpleAlert(title: alertTitle, message: alertMsg)
        }
    }
    func mailComposeController_(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result{
//        case .sent:
//            self.simpleAlert(title: "성공", message: "메일을 보냈습니다.")
//        case .failed:
//            self.simpleAlert(title: "실패", message: "에러가 발생했습니다. 다시 시도해주세요.")
//        @unknown default:
//            break
//        }
        controller.dismiss(animated: true)
    }
}
