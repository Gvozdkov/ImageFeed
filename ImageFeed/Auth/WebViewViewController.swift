import UIKit
import WebKit

// MARK: - protocol WebViewViewControllerDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - protocol WebViewViewControllerProtocol
protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

// MARK: - protocol WebViewViewController
final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        estimatedProgressObservation = webView.observe(
                     \.estimatedProgress,
                      options: [],
                      changeHandler: { [weak self] _, _ in
                          guard let self = self else { return }
                          self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
                      })
    }
    // MARK: - lifestyle
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
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
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

private extension WebViewViewController {
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.fetchCode(from: url)
        }
        return nil
    }
}
//extension WebViewViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let code = fetchCode(from: navigationAction) {
//            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
//            decisionHandler(.cancel)
//        } else {
//            decisionHandler(.allow)
//        }
//    }
//}
//
//private extension WebViewViewController {
//    func loadWebView() {
//        var components = URLComponents(string: APIConstants.authorizeURLString)
//        components?.queryItems = [URLQueryItem(name: "client_id", value: APIConstants.accessKey),
//                                  URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI),
//                                  URLQueryItem(name: "response_type", value: APIConstants.defaultCode),
//                                  URLQueryItem(name: "scope", value: APIConstants.accessScope)]
//        if let url = components?.url {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
//
//    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
//        if let url = navigationAction.request.url,
//           let components = URLComponents(string: url.absoluteString),
//           components.path == APIConstants.authorizationPath,
//           let items = components.queryItems,
//           let codeItem = items.first(where: { $0.name == APIConstants.defaultCode }) {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
//}


