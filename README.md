# 🏞 Picterest

## 👨‍👩‍👦‍👦 팀원 소개

| <center>**Ravi**</center>   |
| -------------------------------------------------------- |
| [<img src="https://github.com/zoa0945.png" width="200">](https://github.com/zoa0945) |
<br>

## 🖥 프로젝트 소개
### **사진 리스트를 보여주고 원하는 사진을 메모와 함께 저장, 삭제 할 수 있는 APP** 

- Images 탭에서 사진 리스트 확인
- 사진 상단의 별 버튼을 클릭하면 메모와 함께 저장 할 수 있는 알림 추가
- 저장 시 FileManager와 CoreData에 저장 후 Saved 탭에 추가
- Saved 탭에서 저장한 사진과 메모를 확인 가능
- 사진을 길게 누르면 삭제 할 수 있는 알림 추가
- 삭제 시 FileManager와 CoreData에서 삭제 후 Images 탭에서 별 버튼 리셋


<br>

## ⏱️ 개발 기간 및 사용 기술

- 개발 기간: 2022.07.25 ~ 2022.07.30 (1주)
- 사용 기술:  `UIKit`, `URLSession`, `NSCache`, `CoreData`, `FileManager`, `MVVM`, `UILongPressGestureRecognizer`

<br>

## 📌 핵심 기술

- 서버 API에서 불러온 사진 리스트 구현

- 첫번째 페이지부터 15개씩 사진 받아와 Pagination 구현

- Network Layer 분리

- 버튼 터치 시 Alert 추가

- CoreData와 FileManager에 사진 정보 저장 및 삭제

<br>

## ✏️ Collectionview Custom Layout 적용 및 Pagination 구현

- CollectionViewFlowLayout을 상속받아 Custom Layout을 만들어 가변 세로 길이의 레이아웃으로 사용  
 -> Protocol을 이용하여 VC에서 사진의 가로, 세로 비율로 셀의 세로 길이를 결정  

```swift
protocol CustomLayoutDelegate: AnyObject {
    func cellHeight(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat
}

extension ImagesViewController: CustomLayoutDelegate {
	// ...
    func cellHeight(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat {
        let inset = collectionView.contentInset
        let cellWidth = (collectionView.bounds.width - (inset.left + inset.right)) / 2
        let imageWidth = CGFloat(randomPhotos[indexPath.item].width)
        let imageHeight = CGFloat(randomPhotos[indexPath.item].height)
        let ratio: CGFloat = imageHeight / imageWidth
        return CGFloat(cellWidth * ratio)
    }
	// ...
}
```

- Collectionview의 prefetchDataSouce를 활용하여 Pagination 기능 구현  
 -> 페이지당 15개의 사진을 표시하고 indexPath.row가 14일 때 다음 페이지를 호출  

```swift
class ImagesViewController: UIViewController {
	// ...
    override func viewDidLoad() {
        super.viewDidLoad()
	// ...
        imageCollectionView.prefetchDataSource = self
    }
}

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
 ```

<br>

## ✏️ CoreData, FileManager에 사진을 저장 및 삭제
- CoreDataModel과 Property를 생성하고 사진과 관련된 정보를 저장 및 삭제  
 -> 저장시 메모와 함께 사진 정보를 저장  
 -> 삭제시 local의 데이터와 함께 CoreData에 저장된 정보까지 삭제  

```swift
class CoreDataManager {
	// ...
    
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appdelegate.persistentContainer.viewContext
    
    func saveData(_ randomPhoto: RandomPhoto, _ memo: String, _ size: [Int]) {
        let filePath = PhotoFileManager.shared.configFileManager(randomPhoto.id)
        let newPhoto = Photo(context: self.context)
        newPhoto.memo = memo
        newPhoto.id = randomPhoto.id
        newPhoto.imagesize = size
        newPhoto.filepath = filePath
        newPhoto.imageurl = randomPhoto.urls.thumb
        
        do {
            try self.context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
	// ...

    func deleteCoreData(_ object: Photo) {
        context.delete(object)
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
 ```

- FileManager의 경로를 설정하고 사진과 관련된 정보를 저장 및 삭제  
 -> 저장시 해당 경로에 파일을 생성하고 파일에 사진 정보를 저장  
 -> 삭제시 해당 경로에 있는 파일의 사진 정보를 삭제  

```swift
class PhotoFileManager {
	// ...
    
    func configFileManager(_ id: String) -> URL {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent("\(id).png")
        
        return filePath
    }
    
    func saveFileManagerData(_ randomPhoto: RandomPhoto) {
        let filePath = configFileManager(randomPhoto.id)
        
        LoadImage().loadImage(randomPhoto.urls.thumb) { result in
            switch result {
            case .success(let image):
                if let data = image.pngData() {
                    do {
                        try data.write(to: filePath)
                    } catch {
                        print("filemanager save error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFileManagerData(_ filePath: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: filePath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
 ```

<br>

## 📱 UI

| 사진 리스트 | 메모 작성 및 저장 | 저장된 사진 리스트 | 저장된 사진 삭제 |
| :----: | :----: | :----: | :----: |
| ![Simulator Screen Recording - iPhone 12 - 2022-07-29 at 18 09 42](https://user-images.githubusercontent.com/51810980/181727904-1be5c705-3207-4126-bae6-b05c3f77899b.gif) | ![Simulator Screen Recording - iPhone 12 - 2022-07-29 at 18 10 17](https://user-images.githubusercontent.com/51810980/181727059-cd0b35f6-9407-456f-a73f-10a5c46ac79f.gif) | ![Simulator Screen Recording - iPhone 12 - 2022-07-29 at 18 10 45](https://user-images.githubusercontent.com/51810980/181727182-4781e05a-3281-4873-9e1e-b98d5b81b3c8.gif) | ![Simulator Screen Recording - iPhone 12 - 2022-07-29 at 18 11 08](https://user-images.githubusercontent.com/51810980/181727454-1d1d88b4-0b0a-41b1-a36e-de4e0e120e60.gif) |
