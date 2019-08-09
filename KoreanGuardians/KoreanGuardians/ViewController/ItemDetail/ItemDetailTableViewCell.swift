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

    func configure(data: String) {
        nameLabel.text = data
        contentLabel.text = data
        dateLabel.text = data
    }
}
