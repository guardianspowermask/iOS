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
    func configure(data: Comment, row: Int) {
        nameLabel.text = data.name
        contentLabel.text = data.comment
        if let date = data.date {
            if date.count > 15 {
                //15 글자 이상인거 date formatting 처리
                let year = String(date.prefix(4))
                let monthStartIdx = date.index(date.startIndex, offsetBy: 5)
                let monthEndIdx = date.index(date.startIndex, offsetBy: 6)
                let dayStartIdx = date.index(date.startIndex, offsetBy: 8)
                let dayEndIdx = date.index(date.startIndex, offsetBy: 9)
                let month = String(date[monthStartIdx...monthEndIdx])
                let day = String(date[dayStartIdx...dayEndIdx])
                dateLabel.text = "\(year) \(month)/\(day)"
            } else {
                dateLabel.text = data.date
            }
        }
        self.row = row
    }
}
