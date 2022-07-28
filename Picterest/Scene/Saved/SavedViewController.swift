//
//  SavedViewController.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class SavedViewController: UIViewController {
    private let viewModel = SceneViewModel()
    var photos: [Photo] = []
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let tableView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "SavedCell")
        photoCollectionView.register(PhotoCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PhotoHeader")
        
        layout()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photos = viewModel.fetchCoreData()
        photoCollectionView.reloadData()
    }
}

extension SavedViewController {
    private func layout() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension SavedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let photo = photos[indexPath.row]
        cell.setup(photo: photo, indexPath: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let imageSize = photos[indexPath.row].imagesize else { return CGSize() }
        let width = collectionView.frame.width - 12
        let ratio = CGFloat(imageSize[1]) / CGFloat(imageSize[0])
        return CGSize(width: width, height: width * ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoHeader", for: indexPath) as? PhotoCollectionViewHeader else { return UICollectionReusableView() }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: 56)
    }
}

extension SavedViewController: UIGestureRecognizerDelegate {
    func setupLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        photoCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        
        let position = gestureRecognizer.location(in: photoCollectionView)
        if let indexPath = photoCollectionView.indexPathForItem(at: position) {
            let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteAction = UIAlertAction(title: "삭제", style: .default) { [weak self] _ in
                guard let self = self,
                      let filePath = self.photos[indexPath.row].filepath else { return }
                
                self.viewModel.deleteFileManagerData(filePath)
                self.viewModel.deleteCoreData(self.photos[indexPath.row])
                
                self.photos.remove(at: indexPath.row)
                self.photoCollectionView.reloadData()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
    }
}
