//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 31.05.2023.
//

import UIKit
import WebKit

// MARK: - protocol WebViewControllerDelegate
protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}

// MARK: - class WebViewController
final class WebViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    // MARK: - lifestyle
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewControllerDidCancel(self)
    }
}


// MARK: - extension
extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension WebViewController {
    private func loadWebView() {
        var urlComponents = URLComponents(string: authorizeURLString)
        urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: accessKey),
                                     URLQueryItem(name: "redirect_uri", value: redirectURI),
                                     URLQueryItem(name: "response_type", value: defaultCode),
                                     URLQueryItem(name: "scope", value: accessScope)]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let components = URLComponents(string: url.absoluteString),
           components.path == authorizationPath,
           let items = components.queryItems,
           let codeItem = items.first(where: { $0.name == defaultCode}) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
