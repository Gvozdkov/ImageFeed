//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 05.06.2023.
//

import Foundation

private let userDefaults = UserDefaults.standard

final class OAuth2TokenStorage {
    var token: String? {
        get {
            userDefaults.string(forKey: "userToken")
        }
        set {
            userDefaults.set(newValue, forKey: "userToken")
        }
    }
}

//private let keychainStorage = KeychainWrapper.standard
//final class OAuth2TokenStorage {
//    static let shared = OAuth2TokenStorage()
//    private enum Keys: String {
//        case bearerToken
//    }
//    private init() { }
//
//    var token: String? {
//        get {
//            keychainStorage.string(forKey: Keys.bearerToken.rawValue)
//        }
//        set {
//            if let token = newValue {
//                keychainStorage.set(token, forKey: Keys.bearerToken.rawValue)
//            } else {
//                keychainStorage.removeObject(forKey: Keys.bearerToken.rawValue)
//            }
//        }
//    }
//    func removeAllKeys() {
//        KeychainWrapper.standard.removeAllKeys()
//    }
//}
