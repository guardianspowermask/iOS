//
//  ItemCollectionViewCell.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        self.backView.makeRounded(cornerRadius: 13)
        self.backView.makeBorder(color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), width: 0.3)
    }
    func configure(data: Category) {
        self.categoryLabel.text = data.name
    }
    func getLabelWidth() -> CGFloat {
        let textCount: CGFloat = CGFloat(self.categoryLabel.text?.count ?? 0)
        return (textCount*14)+22
    }
    func getLabelTxt() -> String {
        return categoryLabel.text ?? ""
    }
    override var isSelected: Bool {
        didSet {
            self.backView.backgroundColor = self.isSelected ? #colorLiteral(red: 0.1411764706, green: 0.537254902, blue: 1, alpha: 1) : #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
            self.categoryLabel.textColor = self.isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
        }
    }
}
