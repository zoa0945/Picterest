//
//  CollectionViewCell.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.backgroundColor = .gray
        
        return photo
    }()
    
    private let titleView: CellTitleView = {
        let view = CellTitleView()
        view.backgroundColor = .darkGray
        view.alpha = 0.5
        
        return view
    }()
    
    func setup(url: String, indexPath: Int) {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        LoadImage().loadImage(url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoImage.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        titleView.setup(indexPath: indexPath)
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewCell {
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
    }
}
