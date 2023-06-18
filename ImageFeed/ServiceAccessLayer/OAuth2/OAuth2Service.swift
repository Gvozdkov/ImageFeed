//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 05.06.2023.
//

import Foundation

// MARK: - class OAuth2Service
final class OAuth2Service {
    fileprivate let unsplashAuthorizeTokenURLString = "https://unsplash.com/oauth/token"
    static let shared = OAuth2Service()
    private let session = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
//    private let token = OAuth2TokenStorage.shared
    
//    private let token = OAuth2TokenStorage.shared
//    static let shared = OAuth2Service()
//    private let urlSession = URLSession.shared
//    private (set) var authToken: String? {
//        get {
//            return OAuth2TokenStorage().token
//        }
//        set {
//            OAuth2TokenStorage().token = newValue
//        }
//    }
    
//    func fetchOAuthToken(
//        _ code: String,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        let request = authTokenRequest(code: code)
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                self.authToken = authToken
//                completion(.success(authToken))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = self.session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let decodedObject):
                completion(.success(decodedObject.accessToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}


// MARK: - extension
//extension OAuth2Service {
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//            }
//            completion(response)
//        }
//    }
//    private func authTokenRequest(code: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/oauth/token" + "?client_id=\(accessKey)" + "&&client_secret=\(secretKey)" + "&&redirect_uri=\(redirectURI)" + "&&code=\(code)" + "&&grant_type=authorization_code",
//            httpMethod: "POST",
//            baseURL: URL(string: "https://unsplash.com")!
//        )
//    }
//
//}

//    // MARK: - HTTP Request
//extension URLRequest {
//    static func makeHTTPRequest(
//        path: String,
//        httpMethod: String,
//        baseURL: URL = defaultBaseURL
//    ) -> URLRequest {
//        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
//        request.httpMethod = httpMethod
//        return request
//    }
//}
extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: unsplashAuthorizeTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
