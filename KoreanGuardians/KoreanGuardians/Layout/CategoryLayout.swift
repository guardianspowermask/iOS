//
//  CategoryLayout.swift
//  KoreanGuardians
//
//  Created by SAY on 26/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

protocol CategoryLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, widthForCategoryAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CategoryLayout: UICollectionViewLayout {
    // 1
    weak var delegate: CategoryLayoutDelegate!
    // 2
    fileprivate var numberOfRows = 1
    fileprivate var cellPadding: CGFloat = 4
    // 3
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    // 4
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
}

extension CategoryLayout {
    override func prepare() {
        // 1
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2
        var column = 0
        let height: CGFloat = 40
        var xOffset = [CGFloat](repeating: 0, count: 1)
        let insets = collectionView.contentInset
        collectionView.contentInset.left = 12
        collectionView.contentInset.right = 12
        let yOffset: CGFloat = CGFloat(((collectionView.bounds.height) - (insets.top + insets.bottom) - height)/2)
        // 3
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            // 4
            let cellWidth = delegate.collectionView(collectionView, widthForCategoryAtIndexPath: indexPath)
            let width = cellPadding * 2 + cellWidth
            let frame = CGRect(x: xOffset[column], y: yOffset, width: width, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: 6)
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            // 6
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[column] = xOffset[column] + width
            column = column < (numberOfRows - 1) ? (column + 1) : 0
        }
    }
}

extension CategoryLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}

extension CategoryLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
