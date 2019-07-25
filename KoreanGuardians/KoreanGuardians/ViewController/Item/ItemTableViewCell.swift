//
//  ItemTableViewCell.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var itemImgView: UIImageView!
    @IBOutlet private weak var blackBackgroundView: UIView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemStoreLabel: UILabel!
    @IBOutlet private weak var itemReportCountLabel: UILabel!
    @IBOutlet private weak var reporntButton: UIButton!
    var reportItemBlock: ((_ row: Int) -> Void)?
    private var row: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setButtonAttr()
        self.setViewRadius()
    }
    func setButtonAttr() {
        self.reporntButton.addTarget(self, action: #selector(report), for: .touchUpInside)
    }
    func setViewRadius() {
        self.itemImgView.makeRounded(cornerRadius: 20)
        self.blackBackgroundView.makeRounded(cornerRadius: 20)
    }
    @objc func report() {
        reportItemBlock?(row ?? 0)
    }
    func setCallback(callback:@escaping (_ row: Int) -> Void) {
        reportItemBlock = callback
    }
    func configure(data: Item, row: Int) {
        //self.itemImgView.kf.setImage(with: URL(string: data.img))
        self.itemNameLabel.text = data.name
        self.itemStoreLabel.text = data.store
        self.itemReportCountLabel.text = data.reportCnt.description
        self.row = row
    }
}
