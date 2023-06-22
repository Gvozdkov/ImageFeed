//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 22.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
