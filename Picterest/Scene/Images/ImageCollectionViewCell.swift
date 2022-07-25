//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.backgroundColor = .gray
        
        return photo
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.5
        
        return view
    }()
    
    func setup() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        layout()
    }
}

extension ImageCollectionViewCell {
    private func layout() {
        [
            photoImage,
            titleView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        photoImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
