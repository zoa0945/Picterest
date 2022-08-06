//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

protocol TitleViewDelegate: AnyObject {
    func downloadImage(_ index: Int)
    func tapStarButtonDelegate(_ cell: UICollectionViewCell, _ starButton: UIButton)
}

class ImageCollectionViewCell: UICollectionViewCell, ReusableCell {
    weak var delegate: TitleViewDelegate?
    var index = 0
    
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.backgroundColor = .gray
        
        return photo
    }()
    
    let titleView: ImageCellTitleView = {
        let view = ImageCellTitleView()
        view.backgroundColor = .darkGray
        view.alpha = 0.5
        
        return view
    }()
    
//    func setup(photo: RandomPhoto, indexPath: Int) {
//        layer.cornerRadius = 12
//        layer.masksToBounds = true
//        index = indexPath
//
//        LoadImage().loadImage(photo.urls.thumb) { result in
//            switch result {
//            case .success(let image):
//                DispatchQueue.main.async {
//                    self.photoImage.image = image
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        titleView.setup(buttonState: photo.isFavorite ,indexPath: indexPath)
//        titleView.starButton.addTarget(self, action: #selector(tapStarButton(sender:)), for: .touchUpInside)
//
//        layout()
//    }
    
    func setup(photo: RandomPhoto?, indexPath: Int) {
        guard let photo = photo else { return }
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        index = indexPath
        
        // TODO: - PhotoURL json에서 String으로 파싱해서 넘겨주기
        LoadImage().loadImage(photo.urls.thumb) { result in
            switch result {
            case .success(let image):
                print("get Image")
                DispatchQueue.main.async {
                    self.photoImage.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        titleView.setup(buttonState: photo.isFavorite ,indexPath: indexPath)
        titleView.starButton.addTarget(self, action: #selector(tapStarButton(sender:)), for: .touchUpInside)
        
        layout()
    }
    
    @objc func tapStarButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.downloadImage(index)
        }
        delegate?.tapStarButtonDelegate(self, titleView.starButton)
    }
}

extension ImageCollectionViewCell {
    private func layout() {
        [
            photoImage,
            titleView
        ].forEach {
            contentView.addSubview($0)
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
