//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 14.05.2023.
//

import UIKit
final class ProfileViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
}