//
//  LaunchScreenViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 23/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {
    private var mainStoryboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        playLaunch()
    }
    func playLaunch() {
        guard let animationName = AnimationJson.allCases.randomElement()?.rawValue, let animationPath = Bundle.main.path(forResource: animationName, ofType: "json") else {
            print("해당 json 파일을 찾을 수 없습니다")
            self.goToMainVC()
            return
        }
        let animation = Animation.filepath(animationPath)
        let animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        self.view.addSubview(animationView)
        animationView.play(completion: { [weak self] (finished) in
            guard let `self` = self else {
                return
            }
            if finished {
               self.goToMainVC()
            }
        })
    }
    func goToMainVC() {
        guard let mainVC = mainStoryboard?.instantiateViewController(withIdentifier: "mainNavi") else {
            return
        }
        self.present(mainVC, animated: true, completion: nil)
    }
}

extension LaunchScreenViewController {
    enum AnimationJson: String, CaseIterable {
        case pumpedUp = "pumped_up"
        case meowBoxSplash4 = "meow_box_splash_4"
    }
}
