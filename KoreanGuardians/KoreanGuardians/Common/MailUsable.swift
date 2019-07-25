//
//  MailUsable.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation
import MessageUI

protocol MailUsable: AlertUsable, MFMailComposeViewControllerDelegate {
    func sendMail(recipents: String, subjectTitle: String, bodyTxt: String)
}

extension MailUsable {
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
    }
}
