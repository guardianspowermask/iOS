//
//  ItemViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import MessageUI

class ItemViewController: UIViewController, NibLoadable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    var selectedCategoryIdx: Int = 0
    var categories: [Category] = []
    var items: [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        selectInitialCategory()
        addItemSampleData()
    }
    @IBAction func sortAction(_ sender: Any) {
        let alert = UIAlertController(title: "정렬기준을 선택하세요", message: nil, preferredStyle: .actionSheet)
        let okTitle = "확인"
        let popularSort = UIAlertAction(title: "인기순", style: .default) { (_) in
            sortAction(sort: 0)
        }
        let latestSort = UIAlertAction(title: "최신순", style: .default) { (_) in
            sortAction(sort: 1)
        }
        let nameSort = UIAlertAction(title: "이름순", style: .default) { (_) in
            sortAction(sort: 2)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(popularSort)
        alert.addAction(latestSort)
        alert.addAction(nameSort)
        alert.addAction(cancleAction)
        func sortAction(sort: Int) {
            print(sort)
        }
        present(alert, animated: true)
    }
    func addItemSampleData() {
        let mocci1 = Item(itemIdx: 0, name: "모찌1", img: "img", reportCnt: 0, store: "씨유", email: "rkdthd1234@naver.com", facebook: "")
        let mocci2 = Item(itemIdx: 1, name: "모찌2", img: "img", reportCnt: 0, store: "gs", email: "rkdthd1234@naver.com", facebook: "")
        let mocci3 = Item(itemIdx: 2, name: "모찌3", img: "img", reportCnt: 0, store: "711", email: "rkdthd1234@naver.com", facebook: "")
        items.append(contentsOf: [mocci1, mocci2, mocci3, mocci1, mocci2, mocci3, mocci1, mocci2, mocci3])
    }
    func selectInitialCategory() {
        self.collectionView.selectItem(at: IndexPath(item: selectedCategoryIdx, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(type: ItemCollectionViewCell.self, for: indexPath)
        cell.configure(data: categories[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        print("select")
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 26)
    }
}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(for: ItemTableViewCell.self)
        cell.configure(data: items[indexPath.row], row: indexPath.row)
        cell.setCallback {[weak self] (row: Int) in
            guard let `self` = self else {
                return
            }
            print("\(self.items[row].itemIdx)에 메일을 보냄")
        }
        return cell
    }
}

//extension ItemViewController: MessageUsable {
//    @objc func sendReport() {
//        //if mail, fb으로 분기
//        let recipents = "gaksital.official@gmail.com"
//        let subjectTitle = "[제보] 일본어 사용 제품 제보합니다!"
//        let bodyTxt = """
//                        <p>이름: 제품명 ex) CU 리얼초코모찌롤</p>
//                        <p>제조사: ex) CJ 푸드빌</p>
//                        <p>한 마디:                 </p>
//                        <p>위 제품을 제보합니다. 각시탈 파이팅 :)</p>
//                      """
//        self.sendMail(recipents: recipents, subjectTitle: subjectTitle, bodyTxt: bodyTxt)
//    }
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        self.mailComposeController_(controller, didFinishWith: result, error: error)
//    }
//}
