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
        if let layout = collectionView.collectionViewLayout as? CategoryLayout {
            layout.delegate = self
        }
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
        let mocci1 = Item(itemIdx: 0, name: "모찌1", img: "img", reportCnt: 0, store: "씨유", email: "", facebook: "100010023481570")
        let mocci2 = Item(itemIdx: 1, name: "모찌2", img: "img", reportCnt: 0, store: "gs", email: "rkdthd1234@naver.com", facebook: "100010023481570")
        let mocci3 = Item(itemIdx: 2, name: "모찌3", img: "img", reportCnt: 0, store: "711", email: "rkdthd1234@naver.com", facebook: "")
        items.append(contentsOf: [mocci1, mocci2, mocci3])
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

extension ItemViewController: CategoryLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        widthForCategoryAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(((categories[indexPath.item].name.count)*14)+24)
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
            self.reportItem(row: row, itemIdx: self.items[row].itemIdx)
        }
        return cell
    }
}

extension ItemViewController {
    func reportItem(row: Int, itemIdx: Int) {
        let bodyTxt = """
        <p>안녕하세요,</p>
        <p>귀사의 (\(items[row].name)) 제품명에 대해 건의할 사항이 있습니다.</p>
        <p>충분히 우리말로 만들 수 있는 제품명에 굳이 일본어를 사용할 필요가 없다고 생각합니다.</p>
        <p>고작 하나의 제품 이름일 뿐이라고 생각하지 말고 언어 사용의 중요성에 대해 인지하시길 바랍니다.</p>
        <p>감사합니다 :)</p>
        """
        if !items[row].email.isEmpty {
            //email
            let itemName = items[row].name
            let recipents = items[row].email
            let subjectTitle = "[\(itemName)] 제품명에 대해서 건의합니다."
            self.sendMail(recipents: recipents, subjectTitle: subjectTitle, bodyTxt: bodyTxt)
        } else if !items[row].facebook.isEmpty {
            //facebook
            UIPasteboard.general.string = bodyTxt.html2String
            self.simpleAlert(title: "샘플 메시지가 복사되었습니다.\n붙여넣기를 해보세요. :)", message: "") { (_) in
                self.sendFM(fbId: self.items[row].facebook)
            }
        } else {
            //둘다 없음
            self.simpleAlert(title: "오류", message: "항의 링크를 제공하고 있지 않는 업체입니다.")
        }
    }
}

// MARK: 이메일
extension ItemViewController: MessageUsable {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.mailComposeController_(controller, didFinishWith: result, error: error)
    }
}

// MARK: 페이스북 메시지
extension ItemViewController {
    func sendFM(fbId: String) {
        guard let msgUrl = URL(string: "https://m.me/\(fbId)") else {
            self.simpleAlert(title: "실패", message: "유효하지 않은 url 입니다")
            return
        }
        UIApplication.shared.open(msgUrl, options: [:], completionHandler: {[weak self] (success) in
            guard let `self` = self else {
                return
            }
            if !success {
                // Messenger is not installed. Open in browser instead.
                guard let url = URL(string: "https://www.facebook.com/\(fbId)") else {
                    self.simpleAlert(title: "실패", message: "유효하지 않은 url 입니다")
                    return
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    self.simpleAlert(title: "실패", message: "해당 페이지를 열수 없습니다")
                }
            }
        })
    }
}
