//
//  UICollectionView+.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) where T: ReusableCell {
        self.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func register<T: UICollectionReusableView>(viewType: T.Type, forSupplementaryViewOfKind: String) where T: ReusableCell {
        self.register(viewType, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: viewType.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(viewType: T.Type, kind: String, indexPath: IndexPath) -> T where T: ReusableCell {
        guard let header = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewType.identifier, for: indexPath) as? T else { fatalError() }
        return header
    }
}
