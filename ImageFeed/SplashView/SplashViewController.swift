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
    private let showWebViewSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = oauth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
        }
    }
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    // MARK: - lifestyle
//
//    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

//MARK: - extension
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSegueIdentifier, let navigationController = segue.destination as? UINavigationController, let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
            prepare(for: segue, sender: sender)
            return
        }
        authViewController.delegate = self
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
//            switch result {
//            case .success:
//                self.switchToTabBarController()
//                UIBlockingProgressHUD.dismiss()
//            case .failure:
//                UIBlockingProgressHUD.dismiss()
//                // TODO Показать ошибку
//
//            }
//        }
//    }
//    private func fetchProfile(token: String) {
//        profileService.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    ProfileImageService.shared.fetchProfileImageURL(username: (self.profileService.profile?.username)!, token: token) { _ in }
//                    self.switchToTabBarController()
//                case .failure:
//                    self.showError()
//                    UIBlockingProgressHUD.dismiss()
//                    self.showNextScreen(withID: "SplashViewController")
//                }
//                UIBlockingProgressHUD.dismiss()
//            }
//        }
//    }

