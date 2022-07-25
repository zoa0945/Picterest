//
//  CellTitleView.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class CellTitleView: UIView {
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(tapStarButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapStarButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.tintColor = .systemYellow
        } else {
            sender.tintColor = .white
        }
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "test"
        
        return label
    }()
    
    func setup() {
        layout()
    }
}

extension CellTitleView {
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
        starButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        indexLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        indexLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor, constant: inset).isActive = true
        indexLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset).isActive = true
        indexLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
    }
}
