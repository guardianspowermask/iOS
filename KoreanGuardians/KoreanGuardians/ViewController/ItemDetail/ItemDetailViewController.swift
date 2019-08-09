//
//  ItemDetailViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/09.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import SnapKit

class ItemDetailViewController: UIViewController, NibLoadable, AlertUsable {

    @IBOutlet private weak var itemImage: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemStoreLabel: UILabel!
    @IBOutlet private weak var reportCountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var textfieldBottomView: UIView!
    @IBOutlet private weak var textfieldBackgroundView: UIView!
    @IBOutlet private weak var commentTextfield: UITextField!
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
        setKeyboardSetting()
        setTextField()
    }
    @IBAction func commentAction(_ sender: Any) {
        //if login
        print("\(commentTextfield.text)로 통신")
        //else
        self.simpleAlert(title: "댓글을 달수 없습니다", message: "로그인 후 이용해주세요", okHandler: {(_) in
            print("로그인 화면 이동")
        })
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
        cell.configure(data: sampleComments[indexPath.row])
        return cell
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
}

//키보드 대응
extension ItemDetailViewController {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textfieldBottomView.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-keyboardSize.height)
            })
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        commentTextfield.text = ""
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        textfieldBottomView.snp.remakeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview()
                // Fallback on earlier versions
            }
        })
        self.view.layoutIfNeeded()
    }
    //화면 바깥 터치했을때 키보드 없어지는 코드
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    @objc func tapBackground() {
        self.commentTextfield.endEditing(true)
    }
}
