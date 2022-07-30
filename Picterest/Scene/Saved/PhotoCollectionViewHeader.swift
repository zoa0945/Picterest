//
//  PhotoCollectionViewHeader.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class PhotoCollectionViewHeader: UICollectionReusableView, ReusableCell {
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "square.and.arrow.down", state: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Saved Images"
        label.textAlignment = .left
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
}

extension PhotoCollectionViewHeader {
    private func layout() {
        [
            downloadButton,
            titleLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let inset: CGFloat = 12
        
        downloadButton.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
        downloadButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset).isActive = true
        downloadButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: downloadButton.trailingAnchor, constant: inset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
    }
}
