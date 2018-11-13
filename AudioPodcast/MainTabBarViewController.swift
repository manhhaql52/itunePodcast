//
//  MainTabBarViewController.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/6/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.brown
        
        setupTabBarVC()
        
    }
    
    func setupTabBarVC() {
        
        let layout = UICollectionViewFlowLayout()
        let favoriteVC = FavoriteViewController(collectionViewLayout: layout)
        
        viewControllers = [
            navVC(for: SearchTableViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            navVC(for: favoriteVC, title: "Favorites", image: #imageLiteral(resourceName: "favorite")),
            navVC(for: DownloadTableViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK: Helper functions
    func navVC(for rootViewController: UIViewController, title: String, image:UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        
        return navController
    }

}
