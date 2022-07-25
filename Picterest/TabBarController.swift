//
//  TabBarController.swift
//  Picterest
//

import UIKit

class TabBarController: UITabBarController {
    
    private let imagesViewController: UIViewController = {
        let viewController = UIViewController()
        let tabBarItem = UITabBarItem(
            title: "Images",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill")
        )
        viewController.tabBarItem  = tabBarItem
        
        return viewController
    }()
    
    private let savedViewController: UIViewController = {
        let viewController = UIViewController()
        let tabBarItem = UITabBarItem(
            title: "Saved",
            image: UIImage(systemName: "star.bubble"),
            selectedImage: UIImage(systemName: "star.bubble.fill")
        )
        viewController.tabBarItem  = tabBarItem
        
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [imagesViewController, savedViewController]
    }
}

