//
//  ItemDetailViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/09.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import SnapKit

class ItemDetailViewController: UIViewController, NibLoadable, AlertUsable, LoginEntry {

    @IBOutlet private weak var itemImage: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemStoreLabel: UILabel!
    @IBOutlet private weak var reportCountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var textfieldBottomView: UIView!
    @IBOutlet private weak var textfieldBackgroundView: UIView!
    @IBOutlet private weak var commentTextfield: UITextField!
    @IBOutlet private weak var feedbackButton: UIButton!
    var selectedItemInfo: (index: Int, name: String, store: String, image: String)?
    private var keyboardDismissGesture: UITapGestureRecognizer?
    var sampleComments = ["hi", "sujin", "hi", "sujin", "hi", "sujin", "hi", "sujin"] {
        didSet {
            self.tableView.reloadData()
            self.reportCountLabel.text = "1"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUI()
        //setupNavigationbar()
        setTextField()
        registerForKeyboardEvents()
    }
    deinit {
        unregisterFromKeyboardEvents()
    }
    @IBAction func commentAction(_ sender: Any) {
        //if login
        if !UserData.isUserLogin {
            self.simpleAlert(title: "댓글을 달수 없습니다", message: "로그인 후 이용해주세요", okHandler: {(_) in
                self.toLoginViewController()
            })
        } else {
             print("\(commentTextfield.text)로 통신")
        }
    }
//    func setupNavigationbar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//    }
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setUI() {
        guard let selectedItemInfo = self.selectedItemInfo else {
            return
        }
        self.itemImage.kf.setImage(with: URL(string: selectedItemInfo.image))
        self.itemNameLabel.text = selectedItemInfo.name
        self.itemStoreLabel.text = "제조사 / "+selectedItemInfo.store
        self.textfieldBackgroundView.makeRounded(cornerRadius: self.textfieldBackgroundView.frame.height/2)
        let feedbackImageName = "grayFeedback"
        self.feedbackButton.setImage(UIImage(named: feedbackImageName), for: .normal)
    }
    func setTextField() {
        self.commentTextfield.delegate = self
    }
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(for: ItemDetailTableViewCell.self)
        cell.configure(data: sampleComments[indexPath.row], row: indexPath.row)
        cell.setCallback {[weak self] (row: Int) in
            guard let self = self else {
                return
            }
            self.showReportAlert(index: row)
            //self.reportItem(row: row, itemIdx: self.items[row].itemIdx)
        }
        return cell
    }
    func showReportAlert(index: Int) {
        let reportAction: [String: ((UIAlertAction) -> Void)?] = ["신고" : {(_) in print("reportreport")}]
        self.simpleActionSheet(title: nil, message: nil, okTitle: "확인", actions: [reportAction])
    }
}

//textField
extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            simpleAlert(title: "오류", message: "검색어를 입력해주세요")
            return false
        }
        if let myString = textField.text {
            let emptySpacesCount = myString.components(separatedBy: " ").count-1
            if emptySpacesCount == myString.count {
                simpleAlert(title: "오류", message: "검색어를 입력하세요")
                return false
            }
        }
        if let searchString = textField.text {
            print("enter 누름")
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !UserData.isUserLogin {
            self.simpleAlert(title: "댓글을 달수 없습니다", message: "로그인 후 이용해주세요", okHandler: {(_) in
                self.toLoginViewController()
            })
        }
    }
}

extension ItemDetailViewController: KeyboardObserving {
    func keyboardWillShow(_ notification: Notification) {
            textfieldBottomView.snp.remakeConstraints({ (make) in
                let keyboardHeight = notification.keyboardSize?.height ?? 0
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            })
            self.view.layoutIfNeeded()
    }
    func keyboardWillHide(_ notification: Notification) {
        commentTextfield.text = ""
        textfieldBottomView.snp.remakeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        })
        self.view.layoutIfNeeded()
    }
}
