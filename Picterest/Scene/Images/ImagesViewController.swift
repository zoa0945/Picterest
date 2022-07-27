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
        
        cell.titleView.delegate = self
        
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
        let inset = collectionView.contentInset
        let cellWidth = (collectionView.bounds.width - (inset.left + inset.right)) / 2
        let imageWidth = CGFloat(imageURLs[indexPath.item].width)
        let imageHeight = CGFloat(imageURLs[indexPath.item].height)
        let ratio: CGFloat = imageHeight / imageWidth
        return CGFloat(cellWidth * ratio)
    }
}

extension ImagesViewController: TitleViewDelegate {
    func downloadImage(_ index: Int) {
        let imageURL = imageURLs[index].urls.thumb
        let alert = UIAlertController(title: "완료", message: "다운로드가 완료되었습니다.", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Memo"
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self,
                  let memo = alert.textFields?[0].text else { return }
            
            let filePath = self.viewModel.configFileManager(index)
            let text = imageURL + "_" + memo
            
            do {
                try text.write(to: filePath, atomically: false, encoding: .utf8)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
    }
}
