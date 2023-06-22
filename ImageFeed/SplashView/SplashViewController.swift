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

    private let oauth2Service = OAuth2Service()
    private var alertPresent: AlertPresenterProtocol?
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let showWebViewSegueIdentifier = "ShowAuthenticationScreen"
    private let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    private var viewImageLogo = UIImageView()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "YP Black")
        setViewImage()
    }
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
        
        //        if let _ = oauth2TokenStorage.token {
        //            switchToTabBarController()
        //        } else {
        //            performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
        //        }
    }
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    // MARK: - lifestyle
    
    private func setViewImage() {
        let imageProfile = UIImage(named: "Logo")
        viewImageLogo = UIImageView(image: imageProfile)
        viewImageLogo.tintColor = .gray
        viewImageLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewImageLogo)
        NSLayoutConstraint.activate([
            viewImageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewImageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewImageLogo.widthAnchor.constraint(equalToConstant: 75),
            viewImageLogo.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
    private func showError() {
         let alertError: AlertModel = {
             AlertModel(
                 title: "Что-то пошло не так",
                 message: "Не удалось войти в систему",
                 buttonText: "Ок") {}
         }()
         self.alertPresent?.showError(error: alertError)
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
                    ProfileImageService.shared.fetchProfileImageURL(username: (self.profileService.profile?.username)!, token: token) { _ in }
                    self.switchToTabBarController()
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

////MARK: - extension
//extension SplashViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == showWebViewSegueIdentifier, let navigationController = segue.destination as? UINavigationController, let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
//            prepare(for: segue, sender: sender)
//            return
//        }
//        authViewController.delegate = self
//    }
//}
//
//extension SplashViewController: AuthViewControllerDelegate {
//    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
//        ProgressHUD.show()
//        dismiss(animated: true) { [weak self] in
//            guard let self = self else { return }
//            //            self.fetchOAuthToken(code)
//        }
//    }
//
//    private func fetchProfile(token: String) {
//        profileService.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    ProfileImageService.shared.fetchProfileImageURL(username: (self.profileService.profile?.username)!, token: token) { _ in }
//                    self.switchToTabBarController()
//                case .failure:
//                                        self.showError()
//                    UIBlockingProgressHUD.dismiss()
////                                        self.showNextScreen(withID: "SplashViewController")
//                }
//                UIBlockingProgressHUD.dismiss()
//            }
//        }
//    }
//}














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

