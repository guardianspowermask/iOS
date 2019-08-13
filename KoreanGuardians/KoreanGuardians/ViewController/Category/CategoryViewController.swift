//
//  CategoryViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import MessageUI

class CategoryViewController: UIViewController, LoginEntry {

    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emailNewItemButton: UIButton!
    var categories: [Category] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
        setLabelAttr()
        setButtonAttr()
        setCollectionView()
        getCategories()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    func setLabelAttr() {
        let attributedString = NSMutableAttributedString(string: "키워드를\n선택하세요")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -1
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        keywordLabel.attributedText = attributedString
    }
    func setButtonAttr() {
        emailNewItemButton.addTarget(self, action: #selector(sendMailNewItem), for: .touchUpInside)
    }
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func checkLogin() {
        if !UserData.isUserLogin {
            self.toLoginViewController()
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(type: CategoryCollectionViewCell.self, for: indexPath)
        cell.configure(data: categories[indexPath.row], isOdd: indexPath.row % 2 == 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemVC = mainStoryboard.viewController(ItemViewController.self)
        itemVC.selectedCategoryRow = indexPath.row
        itemVC.categories = self.categories
        itemVC.selectedCategoryIdx = self.categories[indexPath.row].categoryIdx
        self.show(itemVC, sender: nil)
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width/2
        return CGSize(width: width, height: width)
    }
    //collectionView inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension CategoryViewController: MailUsable {
    @objc func sendMailNewItem() {
        let recipents = "gaksital.official@gmail.com"
        let subjectTitle = "[제보] 일본어 사용 제품 제보합니다!"
        let bodyTxt = """
                        <p>제품명: ex) CU 리얼초코모찌롤</p>
                        <p>제조사: ex) CJ 푸드빌</p>
                        <p>한 마디:                 </p>
                        <p>위 제품을 제보합니다.</p>
                        <p>각시탈 파이팅 :)</p>
                      """
        self.sendMail(recipents: recipents, subjectTitle: subjectTitle, bodyTxt: bodyTxt)
    }
}

extension CategoryViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: network
extension CategoryViewController {
    func getCategories() {
        NetworkManager.sharedInstance.getCategory { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            switch res {
            case .success(let categories):
                self.categories = categories
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
