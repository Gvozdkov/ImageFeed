//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 14.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
   
    private lazy var viewProfileImage: UIImageView = {
        let imageProfile = UIImage(named: "Profile")
        let image = UIImageView(image: imageProfile)
        return image
    }()
    
    private lazy var labelNameProfile: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP Gray")
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private lazy var buttonLogout : UIButton = {
        let imageButton = UIImage(named: "logoutButton")
        var button = UIButton()
        button = UIButton.systemButton(with: imageButton!, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
    }
}

// MARK: - Settings View Controller

private extension ProfileViewController {
    func settingsViewController() {
        view = UIView()
        view.backgroundColor = UIColor(named: "YP Black")
        
        view.addSubview(viewProfileImage)
        view.addSubview(labelNameProfile)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(buttonLogout)
        
        viewProfileImage.translatesAutoresizingMaskIntoConstraints = false
        labelNameProfile.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewProfileImage.heightAnchor.constraint(equalToConstant: 70),
            viewProfileImage.widthAnchor.constraint(equalToConstant: 70),
            
            labelNameProfile.topAnchor.constraint(equalTo: viewProfileImage.bottomAnchor, constant: 8),
            labelNameProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: labelNameProfile.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonLogout.centerYAnchor.constraint(equalTo: viewProfileImage.centerYAnchor),
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    
    @objc func didTapLogoutButton() { }
    
}


