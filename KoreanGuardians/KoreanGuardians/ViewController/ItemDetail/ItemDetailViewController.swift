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
    @IBOutlet private weak var defaultView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var textfieldBottomView: UIView!
    @IBOutlet private weak var textfieldBackgroundView: UIView!
    @IBOutlet private weak var commentTextfield: UITextField!
    @IBOutlet private weak var feedbackButton: UIButton!
    var selectedItemInfo: (index: Int?, name: String?, store: String?, image: String?, feedbackFlag: Int?, reportFlag: Bool?)?
    private var keyboardDismissGesture: UITapGestureRecognizer?
    var comments: [Comment] = [] {
        didSet {
            self.tableView.reloadData()
            self.reportCountLabel.text = comments.count.description
            self.setDefaultView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUI()
        setData()
        setupNavigationbar()
        setTextField()
        registerForKeyboardEvents()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .black
    }
    deinit {
        unregisterFromKeyboardEvents()
    }
    @IBAction func toFeedback(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let feedbackVC = mainStoryboard.viewController(FeedbackViewController.self)
        feedbackVC.selectedItemInfo = (self.selectedItemInfo?.index, self.selectedItemInfo?.store)
        self.viewController.present(feedbackVC, animated: true)
    }
    @IBAction func commentAction(_ sender: Any) {
        self.commentTextfield.resignFirstResponder()
        if let reportFlag = selectedItemInfo?.reportFlag, let itemIdx = selectedItemInfo?.index {
            if reportFlag {
                self.simpleAlert(title: "", message: "항의는 한 번만 할 수 있습니다.")
            } else {
                self.writeComment(itemIdx: itemIdx, content: commentTextfield.text ?? "")
            }
        } else {
            showLoginAlert()
        }
    }
    func setupNavigationbar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setUI() {
        guard let selectedItemInfo = self.selectedItemInfo else {
            return
        }
        self.itemImage.kf.setImage(with: URL(string: selectedItemInfo.image ?? ""))
        self.itemNameLabel.text = selectedItemInfo.name
        self.itemStoreLabel.text = "제조사 / \(selectedItemInfo.store ?? "")"
        self.textfieldBackgroundView.makeRounded(cornerRadius: self.textfieldBackgroundView.frame.height/2)
        if let feedbackFlag = selectedItemInfo.feedbackFlag {
            let feedbackImageName = feedbackFlag == 0 ? "grayFeedback" : "buFeedback"
            self.feedbackButton.isUserInteractionEnabled = feedbackFlag == 1
            self.feedbackButton.setImage(UIImage(named: feedbackImageName), for: .normal)
        }
        self.setDefaultView()
    }
    func setData() {
        guard let selectedItemInfo = self.selectedItemInfo, let itemIdx = selectedItemInfo.index else {
            return
        }
        self.getComment(itemIdx: itemIdx)
    }
    func setTextField() {
        self.commentTextfield.delegate = self
    }
    func showLoginAlert() {
        self.simpleAlert(title: "댓글을 달수 없습니다", message: "로그인 후 이용해주세요", okHandler: {(_) in
            self.toLoginViewController()
        })
    }
    func setDefaultView() {
        self.defaultView.isHidden = comments.count > 0
    }
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(for: ItemDetailTableViewCell.self)
        cell.configure(data: comments[indexPath.row], row: indexPath.row)
        cell.setCallback {[weak self] (row: Int) in
            guard let self = self else {
                return
            }
            if !UserData.isUserLogin {
                self.showLoginAlert()
            } else {
                guard let commentIdx = self.comments[row].userCommentIdx else {
                    return
                }
                self.showReportAlert(index: commentIdx)
            }
        }
        return cell
    }
    func showReportAlert(index: Int) {
        let reportAction: [String: ((UIAlertAction) -> Void)?] = ["신고": {[weak self] (_) in
            guard let self = self else {
                return
            }
            self.reportComment(commentIdx: index)
            }]
        self.simpleActionSheet(title: nil, message: nil, okTitle: "확인", actions: [reportAction])
    }
}

//textField
extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentAction(textField)
        return true
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

// 통신
extension ItemDetailViewController {
    func writeComment(itemIdx: Int, content: String) {
        NetworkManager.sharedInstance.writeComment(itemIdx: itemIdx, content: content) { [weak self] (res) in
            guard let self = self else {
                return
            }
            switch res {
            case .success:
                self.simpleAlert(title: "성공", message: "성공적으로 항의 댓글을 등록했습니다")
                self.commentTextfield.text = ""
                self.selectedItemInfo?.reportFlag = true
                self.setData()
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
    func getComment(itemIdx: Int) {
        NetworkManager.sharedInstance.getComment(itemIdx: itemIdx) { [weak self] (res) in
            guard let self = self else {
                return
            }
            switch res {
            case .success(let comments):
                self.comments = comments.reversed()
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

    func reportComment(commentIdx: Int) {
        NetworkManager.sharedInstance.reportComment(commentIdx: commentIdx) { [weak self] (res) in
            guard let self = self else {
                return
            }
            switch res {
            case .success:
                self.simpleAlert(title: "성공", message: "신고가 접수되었습니다")
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
