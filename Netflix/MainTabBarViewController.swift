//
//  ViewController.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 08/03/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let home = UINavigationController(rootViewController: HomeViewController())
        let upcoming = UINavigationController(rootViewController: UpcomingViewController())
        let search = UINavigationController(rootViewController: SearchViewController())
        let downloads = UINavigationController(rootViewController: DownloadsViewController())
    
        home.tabBarItem.image = UIImage(systemName: "house")
        home.tabBarItem.title = "Home"
        
        upcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        upcoming.tabBarItem.title = "Coming soon"
        
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        search.tabBarItem.title = "Search"
        
        downloads.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloads.tabBarItem.title = "Downloads"
        
        setViewControllers([home, upcoming, search, downloads], animated: true)
    }


}

