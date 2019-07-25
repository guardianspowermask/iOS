//
//  CategoryViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import MessageUI

class CategoryViewController: UIViewController {

    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emailNewItemButton: UIButton!
    var categories: [Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelAttr()
        setButtonAttr()
        setCollectionView()
        addSampleData()
    }
    func addSampleData() {
        let mocci = Category(categoryIdx: 0, name: "모찌", itemCnt: 1, img: "https://4guardians.s3.ap-northeast-2.amazonaws.com/guardians/2019/07/25/cat.jpeg", replaceWords: ["찹쌀", "찰떡"])
        let ramen =  Category(categoryIdx: 1, name: "라멘", itemCnt: 2, img: "https://4guardians.s3.ap-northeast-2.amazonaws.com/guardians/2019/07/25/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-05%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%206.24.08.png", replaceWords: ["라면", "일본 라면"])
        let whole = Category(categoryIdx: 2, name: "전체", itemCnt: 2, img: "goods/2019/07/25/%E1%84%82%E1%85%A3%E1%84%8B%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%B5%20%E1%84%82%E1%85%A1%E1%84%8B%E1%85%B5.jpg", replaceWords: ["라면", "일본 라면"])
        categories.append(contentsOf: [mocci, ramen, whole, mocci, ramen, whole, mocci, ramen, whole])
    }
    func setLabelAttr() {
        let attributedString = NSMutableAttributedString(string: "키워드를\n선택하세요")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -1
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        keywordLabel.attributedText = attributedString
    }
    func setButtonAttr() {
        emailNewItemButton.addTarget(self, action: #selector(sendMailNewItem), for: .touchUpInside)
    }
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
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
        itemVC.selectedCategoryIdx = indexPath.row
        itemVC.categories = self.categories
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

extension CategoryViewController: MessageUsable {
    @objc func sendMailNewItem() {
        let recipents = "gaksital.official@gmail.com"
        let subjectTitle = "[제보] 일본어 사용 제품 제보합니다!"
        let bodyTxt = """
                        <p>제품명: ex) CU 리얼초코모찌롤</p>
                        <p>제조사: ex) CJ 푸드빌</p>
                        <p>한 마디:                 </p>
                        <p>위 제품을 제보합니다. 각시탈 파이팅 :)</p>
                      """
        self.sendMail(recipents: recipents, subjectTitle: subjectTitle, bodyTxt: bodyTxt)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.mailComposeController_(controller, didFinishWith: result, error: error)
    }
}
