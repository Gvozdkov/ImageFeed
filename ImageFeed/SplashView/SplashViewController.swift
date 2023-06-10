//
//  SplashView.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 06.06.2023.
//

import UIKit
//MARK: - SplashViewController
final class SplashViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
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
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            self?.dismiss(animated: true) { [weak self] in
                switch result {
                case .success:
                    self?.switchToTabBarController()
                case .failure:
                    break
                }
            }
        }
    }
}

