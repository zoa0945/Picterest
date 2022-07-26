//
//  ImagesViewController.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class ImagesViewController: UIViewController {
    private let viewModel = ImagesViewModel()
    var imageURLs: [RandomPhoto] = [] {
        didSet {
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = ImageCollectionViewCustomLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getImageURLs { result in
            switch result {
            case .success(let photos):
                self.imageURLs += photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        layout()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
}

extension ImagesViewController {
    private func layout() {
        view.addSubview(imageCollectionView)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let imageURL = imageURLs[indexPath.item].urls.thumb
        cell.setup(url: imageURL, indexPath: indexPath.row)
        
        return cell
    }
}

extension ImagesViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if ($0.row + 1) % 15 == 0 {
                viewModel.getImageURLs { result in
                    switch result {
                    case .success(let photos):
                        self.imageURLs += photos
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension ImagesViewController: CustomLayoutDelegate {
    func cellHeight(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat {
        // TODO: - cellHeight 정해주기
        return CGFloat(imageURLs[indexPath.item].height / 15)
    }
}
