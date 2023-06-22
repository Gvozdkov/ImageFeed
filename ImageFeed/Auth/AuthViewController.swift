//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 31.05.2023.
//

import UIKit

//MARK: - protocol AuthViewControllerDelegate
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

//MARK: - class AuthViewController
final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuthService = OAuth2Service()
    private let oAuthStorage = OAuth2TokenStorage.shared
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSegueIdentifier,
              let webViewController = segue.destination as? WebViewController else {
            super.prepare(for: segue, sender: sender)
            return
        }
        webViewController.delegate = self
    }
}
//MARK: - extension
extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        oAuthService.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oAuthStorage.token = token
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}



//reserv

////MARK: - protocol AuthViewControllerDelegate
//protocol AuthViewControllerDelegate: AnyObject {
//    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
//}
//
////MARK: - class AuthViewController
//final class AuthViewController: UIViewController {
//    private let showWebViewSegueIdentifier = "ShowWebView"
//
//    weak var delegate: AuthViewControllerDelegate?
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == showWebViewSegueIdentifier,
//              let webViewController = segue.destination as? WebViewController else {
//            super.prepare(for: segue, sender: sender)
//            return
//        }
//        webViewController.delegate = self
//    }
//}
////MARK: - extension
//extension AuthViewController: WebViewControllerDelegate {
//    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
//        delegate?.authViewController(self, didAuthenticateWithCode: code)
//    }
//
//
//    func webViewControllerDidCancel(_ vc: WebViewController) {
//        dismiss(animated: true)
//    }
//}
