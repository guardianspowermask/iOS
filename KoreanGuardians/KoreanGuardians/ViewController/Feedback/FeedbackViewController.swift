//
//  FeedbackViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/14.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import Kingfisher

class FeedbackViewController: UIViewController, NibLoadable {

    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var feedbackImage: UIImageView!
    var selectedItemInfo: (index: Int?, store: String?)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        guard let selectedItemInfo = selectedItemInfo, let itemIdx = selectedItemInfo.index else {
            return
        }
         getFeedback(itemIdx: itemIdx)
    }
    func setUI() {
        self.feedbackView.makeRounded(cornerRadius: 16)
    }
    @IBAction func touchOutsdie(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FeedbackViewController: AlertUsable {
    func getFeedback(itemIdx: Int) {
        NetworkManager.sharedInstance.getFeedback(itemIdx: itemIdx) { [weak self] (res) in
            guard let self = self else {
                return
            }
            switch res {
            case .success(let feedback):
                self.titleLabel.text = "\(self.selectedItemInfo?.store ?? "") 피드백"
                if let date = feedback.date {
                    let subString = String(date.prefix(10)).replacingOccurrences(of: "-", with: ".")
                    self.dateLabel.text = subString
                }
                guard let feedbackImgURLString = feedback.img, let feedbackImgURL = URL(string: feedbackImgURLString) else {
                    return
                }
                KingfisherManager.shared.retrieveImage(with: feedbackImgURL, options: nil, progressBlock: nil, completionHandler: { image, error, _, _ in
                    if error == nil {
                        self.feedbackImage.image = image
                        guard let originalImageWidth = image?.size.width, let originalImageHeight = image?.size.height else {
                            return
                        }
                        let imageViewWidth = self.feedbackImage.frame.width
                        self.imageHeight.constant = (imageViewWidth * originalImageHeight) / originalImageWidth
                    }
                })
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
