//
//  SplashView.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 06.06.2023.
//

import UIKit
import ProgressHUD

//MARK: - SplashViewController
final class SplashViewController: UIViewController {

    private let oAuth2Service = OAuth2Service()
    private var alertPresent: AlertPresenterProtocol?
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let showWebViewSegueIdentifier = "ShowAuthenticationScreen"
    
    private let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    
    private lazy var viewImageLogo: UIImageView = {
        let viewImage = UIImage(named: "Logo")
        let image = UIImageView(image: viewImage)
        image.tintColor = .gray
        return image
    }()
   
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewImage()
    }
   
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - lifestyle
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func checkAuthorization() {
        if let token = oAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
                    as? AuthViewController else { return }
            present(authViewController, animated: true)
        }
    }
    
    private func showNextScreen(withID screenID: String) {
        let nextViewController = storyboardInstance.instantiateViewController(withIdentifier: screenID)
        UIApplication.shared.windows.first?.rootViewController = nextViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let username = self.profileService.profile?.username else { return }
                    self.profileImageService.fetchProfileImageURL(username: username, token: token)  { _ in }
                    DispatchQueue.main.async {
                        self.switchToTabBarController()
                    }
                case .failure:
                    self.showError()
                    UIBlockingProgressHUD.dismiss()
                    self.showNextScreen(withID: "SplashViewController")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

//MARK: - extension

extension SplashViewController {
    private func setViewImage() {
        view.addSubview(viewImageLogo)
        
        viewImageLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewImageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewImageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewImageLogo.widthAnchor.constraint(equalToConstant: 75),
            viewImageLogo.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
}

extension SplashViewController {
    private func showError() {
        let alertError: AlertModel = {
            AlertModel(
                title: "Что-то пошло не так",
                message: "Не удалось войти в систему",
                buttonText: "Ок") { }
        }()
        self.alertPresent?.showError(error: alertError)
    }
}
