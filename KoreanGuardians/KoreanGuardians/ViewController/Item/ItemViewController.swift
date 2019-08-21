//
//  ItemViewController.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
//import MessageUI

class ItemViewController: UIViewController, NibLoadable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var itemCountLabel: UILabel!
    @IBOutlet private weak var orderLabel: UILabel!
    var categories: [Category] = []
    var isStorePosition = false
    var items: [Item] = [] {
        didSet {
            if isStorePosition {
                //Step 1 Detect & Store
                let topWillBeAt = getTopVisibleRow()
                let oldHeightDifferenceBetweenTopRowAndNavBar = heightDifferenceBetweenTopRowAndNavBar()
                //Step 2 reload
                self.tableView.reloadData()
                //Step 3 Restore Scrolling
                tableView.scrollToRow(at: IndexPath(row: topWillBeAt, section: 0), at: .top, animated: false)
                if topWillBeAt == 0 {
                    tableView.contentOffset.y -= 40
                    return
                }
                tableView.contentOffset.y -= oldHeightDifferenceBetweenTopRowAndNavBar
                //밀리는 현상 방지
                tableView.contentOffset.y += 44
            } else {
                self.tableView.reloadData()
                let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                //tableview header 보이게
                self.tableView.contentOffset.y -= 40
            }
        }
    }
    var selectedCategoryRow: Int = 0
    var selectedCategoryIdx: Int = 0
    var selectedOrder: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        setCollectionView()
        setTableView()
        selectInitialCategory()
    }
    override func viewWillAppear(_ animated: Bool) {
        getItems(isStorePosition: true)
    }

    @IBAction func sortAction(_ sender: Any) {
        let popularSort: [String: ((UIAlertAction) -> Void)?] = ["인기순": {(_) in sortAction(sort: 0)}]
        let latestSort: [String: ((UIAlertAction) -> Void)?] = ["최신순": {(_) in sortAction(sort: 1)}]
        let nameSort: [String: ((UIAlertAction) -> Void)?] = ["이름순": {(_) in sortAction(sort: 2)}]
        self.simpleActionSheet(title: "정렬기준을 선택하세요", message: nil, okTitle: "취소", actions: [popularSort, latestSort, nameSort])
        func sortAction(sort: Int) {
            selectedOrder = sort
            getItems(isStorePosition: false)
        }
    }
    func selectInitialCategory() {
        self.collectionView.selectItem(at: IndexPath(item: selectedCategoryRow, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? CategoryLayout {
            layout.delegate = self
        }
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
        selectedCategoryIdx = categories[indexPath.row].categoryIdx ?? 0
        getItems(isStorePosition: false)
    }
}

extension ItemViewController: CategoryLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        widthForCategoryAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(((categories[indexPath.item].name?.count ?? 0)*14)+24)
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
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let itemDetailVC = mainStoryboard.viewController(ItemDetailViewController.self)
            let selectedItem = self.items[row]
            itemDetailVC.selectedItemInfo = (selectedItem.itemIdx, selectedItem.name, selectedItem.store, selectedItem.img, selectedItem.feedbackFlag, selectedItem.reportFlag)
            self.show(itemDetailVC, sender: nil)
        }
        return cell
    }
}

// MARK: network
extension ItemViewController: AlertUsable {
    func getItems(isStorePosition: Bool) {
        NetworkManager.sharedInstance.getItem(categoryIdx: selectedCategoryIdx, order: selectedOrder) { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            self.isStorePosition = isStorePosition
            switch res {
            case .success(let data):
                self.items = data.items ?? []
                self.itemCountLabel.text = (data.totalCnt ?? 0).description + "건"
                var orderTxt = ""
                switch self.selectedOrder {
                case 0:
                   orderTxt = "인기순"
                case 1:
                   orderTxt = "최신순"
                case 2:
                   orderTxt = "이름순"
                default:
                    break
                }
                self.orderLabel.text = orderTxt
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
//TableView Scroll
extension ItemViewController {
    func getTopVisibleRow () -> Int {
        //We need this to accounts for the translucency below the nav bar
        let navBar = navigationController?.navigationBar
        let whereIsNavBarInTableView = tableView.convert(navBar?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0), from: navBar)
        let pointWhereNavBarEnds = CGPoint(x: 0, y: whereIsNavBarInTableView.origin.y + whereIsNavBarInTableView.size.height + 1)
        let accurateIndexPath = tableView.indexPathForRow(at: pointWhereNavBarEnds)
        return accurateIndexPath?.row ?? 0
    }
    
    func heightDifferenceBetweenTopRowAndNavBar()-> CGFloat{
        let rectForTopRow = tableView.rectForRow(at:IndexPath(row:  getTopVisibleRow(), section: 0))
        let navBar = navigationController?.navigationBar
        let whereIsNavBarInTableView = tableView.convert(navBar?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0), from: navBar)
        let pointWhereNavBarEnds = CGPoint(x: 0, y: whereIsNavBarInTableView.origin.y + whereIsNavBarInTableView.size.height)
        let rectForTopRowY = rectForTopRow.origin.y
        let pointWhereNavBarEndsY = pointWhereNavBarEnds.y
        let differenceBetweenTopRowAndNavBar = rectForTopRowY - pointWhereNavBarEndsY
        return differenceBetweenTopRowAndNavBar
    }
}
