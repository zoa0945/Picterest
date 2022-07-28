//
//  ImagesViewController.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class ImagesViewController: UIViewController {
    private let viewModel = SceneViewModel()
    private var currentPage = 1
    
    var randomPhotos: [RandomPhoto] = [] {
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
        
        viewModel.getImageURLs(currentPage) { result in
            switch result {
            case .success(let photos):
                self.currentPage += 1
                self.randomPhotos += photos
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
        return randomPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
//        let imageURL = randomPhotos[indexPath.item].urls.thumb
        let randomPhoto = randomPhotos[indexPath.item]
        cell.setup(photo: randomPhoto, indexPath: indexPath.row)
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - prefetch api data
extension ImagesViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1) / 15 + 1 == currentPage {
                viewModel.getImageURLs(currentPage) { result in
                    switch result {
                    case .success(let photos):
                        self.currentPage += 1
                        self.randomPhotos += photos
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - CustomLayoutDelegate: Config Cell Height
extension ImagesViewController: CustomLayoutDelegate {
    func cellHeight(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat {
        let inset = collectionView.contentInset
        let cellWidth = (collectionView.bounds.width - (inset.left + inset.right)) / 2
        let imageWidth = CGFloat(randomPhotos[indexPath.item].width)
        let imageHeight = CGFloat(randomPhotos[indexPath.item].height)
        let ratio: CGFloat = imageHeight / imageWidth
        return CGFloat(cellWidth * ratio)
    }
}

// MARK: - TitleViewDelegate: present alert and save data
extension ImagesViewController: TitleViewDelegate {
    func tapStarButtonDelegate(_ cell: UICollectionViewCell, _ starButton: UIButton) {
        let index = imageCollectionView.indexPath(for: cell)
        randomPhotos[(index?.row)!].isFavorite = starButton.isSelected
        imageCollectionView.reloadData()
    }
    
    func downloadImage(_ index: Int) {
        let randomPhoto = randomPhotos[index]
        let size = [randomPhoto.width, randomPhoto.height]
        let alert = UIAlertController(title: "완료", message: "다운로드가 완료되었습니다.", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Memo"
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.randomPhotos[index].isFavorite = false
            NotificationCenter.default.post(name: Notification.Name("cancel"), object: nil)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self,
                  let memo = alert.textFields?[0].text else { return }
            
            self.viewModel.saveData(randomPhoto, memo, size)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
    }
}
