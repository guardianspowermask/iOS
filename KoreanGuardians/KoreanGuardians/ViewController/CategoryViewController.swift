//
//  CategoryViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var categories: [Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelAttr(label: keywordLabel)
        setCollectionView()
        addSampleData()
    }
    func addSampleData() {
        let mocci = Category(categoryIdx: 0, name: "모찌", itemCnt: 1, img: "goods/2019/07/25/%E1%84%82%E1%85%A3%E1%84%8B%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%B5%20%E1%84%82%E1%85%A1%E1%84%8B%E1%85%B5.jpg", replaceWords: ["찹쌀", "찰떡"])
        let ramen =  Category(categoryIdx: 1, name: "라멘", itemCnt: 2, img: "goods/2019/07/25/%E1%84%82%E1%85%A3%E1%84%8B%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%B5%20%E1%84%82%E1%85%A1%E1%84%8B%E1%85%B5.jpg", replaceWords: ["라면", "일본 라면"])
        let whole = Category(categoryIdx: 2, name: "전체", itemCnt: 2, img: "goods/2019/07/25/%E1%84%82%E1%85%A3%E1%84%8B%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%B5%20%E1%84%82%E1%85%A1%E1%84%8B%E1%85%B5.jpg", replaceWords: ["라면", "일본 라면"])
        categories.append(contentsOf: [mocci, ramen, whole, mocci, ramen, whole, mocci, ramen, whole])
    }
    @IBAction func emailNewItem(_ sender: Any) {
        print("email")
    }
    func setLabelAttr(label: UILabel) {
        let attributedString = NSMutableAttributedString(string: "키워드를\n선택하세요")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -1
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
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
        print("aa")
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
