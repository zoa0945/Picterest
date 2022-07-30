//
//  SavedCellTitleView.swift
//  Picterest
//
//  Created by Mac on 2022/07/27.
//

import UIKit

class SavedCellTitleView: UIView {
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "star.fill", state: .normal)
        button.tintColor = .systemYellow
        
        return button
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    func setup(memo: String) {
        layout()
        indexLabel.text = memo
    }
}

extension SavedCellTitleView {
    private func layout() {
        [
            starButton,
            indexLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let inset: CGFloat = 12
        
        starButton.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        starButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset).isActive = true
        starButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        indexLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        indexLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor, constant: inset).isActive = true
        indexLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset).isActive = true
        indexLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
    }
}
