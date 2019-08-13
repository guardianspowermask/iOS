//
//  FeedbackViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/14.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedbackImage.makeRounded(cornerRadius: 16)
    }
    @IBAction func touchOutsdie(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
