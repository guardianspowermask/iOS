//
//  LaunchScreenViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 23/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LaunchScreenViewController: UIViewController {
    private var mainStoryboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    @IBOutlet var splashGifImg: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        playGIF()
    }
    func playGIF() {
        let delayInSeconds = 3.2
        let image = UIImage.gif(name: "pealluck")
        splashGifImg.image = image
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.goToMainVC()
        }
    }
    func goToMainVC() {
        guard let mainVC = mainStoryboard?.instantiateViewController(withIdentifier: "mainNavi") else {
            return
        }
        self.present(mainVC, animated: true, completion: nil)
    }
}
