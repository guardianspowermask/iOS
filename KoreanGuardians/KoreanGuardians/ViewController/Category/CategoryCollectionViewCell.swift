//
//  CategoryCollectionViewCell.swift
//  KoreanGuardians
//
//  Created by 강수진 on 25/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var categoryReplacementLabel: UILabel!
    private var isOdd: Bool = true
    func configure(data: Category, isOdd: Bool) {
        self.categoryImageView.kf.setImage(with: URL(string: data.img))
        self.categoryName.text = data.name
        self.categoryCount.text = data.itemCnt.description
        var replacemetWord = ""
        for word in data.replaceWords {
            replacemetWord += "#\(word) "
        }
        self.categoryReplacementLabel.text = replacemetWord
        self.isOdd = isOdd
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addHorizontalLine(isOdd: isOdd)
        if !isOdd {
            addVerticalLine()
        }
    }
    func addVerticalLine() {
        let width = CGFloat(0.3)
        let height = self.contentView.frame.height
        let xPoint = self.contentView.frame.width - CGFloat(0.3)
        let verticalLine = UIView(frame: CGRect(x: xPoint, y: 0, width: width, height: height))
        verticalLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        self.contentView.addSubview(verticalLine)
    }
    func addHorizontalLine(isOdd: Bool) {
        let margin: CGFloat = 16
        let xPoint = isOdd ? 0 : margin
        let yPoint = self.contentView.frame.height - CGFloat(0.3)
        let width = self.contentView.frame.width-margin
        let height = CGFloat(0.3)
        let verticalLine = UIView(frame: CGRect(x: xPoint, y: yPoint, width: width, height: height))
        verticalLine.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        self.contentView.addSubview(verticalLine)
    }
}
