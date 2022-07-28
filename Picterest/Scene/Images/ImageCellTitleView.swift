//
//  CellTitleView.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class ImageCellTitleView: UIView {
    var index = 0
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "star", state: .normal)
        button.setImage(systemName: "star.fill", state: .selected)
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
    
    func setup(buttonState: Bool, indexPath: Int) {
        index = indexPath
        layout()
        indexLabel.text = "\(indexPath)번째 사진"
        starButton.isSelected = buttonState
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStarButtonState), name: Notification.Name("cancel"), object: nil)
    }
    
    @objc func changeStarButtonState() {
        self.starButton.isSelected = false
    }
}

extension ImageCellTitleView {
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
