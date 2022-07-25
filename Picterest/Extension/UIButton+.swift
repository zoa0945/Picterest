//
//  UIButton+.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

extension UIButton {
    func setImage(systemName: String, state: UIControl.State) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        
        setImage(UIImage(systemName: systemName), for: state)
    }
}
