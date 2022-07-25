//
//  ImageCollectionViewCustomLayout.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
    func cellHeight(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat
}

class ImageCollectionViewCustomLayout: UICollectionViewLayout {
    weak var delegate: CustomLayoutDelegate?
    
    let numberOfCells = 2
    let cellPadding: CGFloat = 6
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    var height: CGFloat = 0
    var width: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let inset = collectionView.contentInset
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let cellWidth = width / CGFloat(numberOfCells)
        var cell = 0
        let x = [0, cellWidth]
        var y = [CGFloat](repeating: 0, count: numberOfCells)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellHeight = delegate?.cellHeight(collectionView, indexPath) ?? 0
            let frame = CGRect(x: x[cell], y: y[cell], width: cellWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            height = max(height, frame.maxY)
            y[cell] = y[cell] + cellHeight
            
            cell = y[0] > y[1] ? 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
