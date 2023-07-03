import UIKit
import WebKit

// MARK: - protocol WebViewViewControllerDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - protocol WebViewViewController
final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - life cycle
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
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - Extensions
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func loadWebView() {
        var components = URLComponents(string: APIConstants.authorizeURLString)
        components?.queryItems = [URLQueryItem(name: "client_id", value: APIConstants.accessKey),
                                  URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI),
                                  URLQueryItem(name: "response_type", value: APIConstants.defaultCode),
                                  URLQueryItem(name: "scope", value: APIConstants.accessScope)]
        if let url = components?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let components = URLComponents(string: url.absoluteString),
           components.path == APIConstants.authorizationPath,
           let items = components.queryItems,
           let codeItem = items.first(where: { $0.name == APIConstants.defaultCode }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}


