//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 31.05.2023.
//

import UIKit
// MARK: - protocol AuthViewControllerDelegate
protocol AuthViewControllerDelegate : AnyObject {
    func authViewController(_ vc : AuthViewController, didAuthenticateWithCode code: String)
}
// MARK: - class AuthViewController
final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    private let oAuthService = OAuth2Service()
    private let oAuthStorage = OAuth2TokenStorage.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewController = segue.destination as?
                    WebViewController
            else { assertionFailure("Failed to prepare for: \(showWebViewSegueIdentifier)")
                return
            }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

// MARK: - Extension

extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}
