//
//  ItemDetailTableViewCell.swift
//  KoreanGuardians
//
//  Created by 강수진 on 2019/08/09.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class ItemDetailTableViewCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var reporntButton: UIButton!
    var reportItemBlock: ((_ row: Int) -> Void)?
    private var row: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setButtonAttr()
    }
    func setButtonAttr() {
        self.reporntButton.addTarget(self, action: #selector(report), for: .touchUpInside)
    }
    @objc func report() {
        reportItemBlock?(row ?? 0)
    }
    func setCallback(callback:@escaping (_ row: Int) -> Void) {
        reportItemBlock = callback
    }
    func configure(data: String, row: Int) {
        nameLabel.text = data
        contentLabel.text = data
        dateLabel.text = data
        self.row = row
    }
}

