//
//  Profile.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 15.06.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let bio: String
    var login: String
    
    init(decodedData: ProfileResult) {
        self.username = decodedData.username ?? ""
        self.name = (decodedData.firstName ?? "") + " " + (decodedData.lastName ?? "")
        self.login = "@" + (decodedData.username ?? "")
        self.bio = decodedData.bio ?? ""
    }
}

struct ProfileResult: Decodable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

private enum CodingKeysForProfileResult: String, CodingKey {
    case username = "user_name"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
}

//struct Profile: Decodable {
//    let userName: String?
//    let name: String?
//    let bio: String?
//    let login: String?
//
//    init (decoderData: ProfileResult) {
//        self.userName = decoderData.userName
//        self.name = (decoderData.firstName ?? "") + " " + (decoderData.lastName ?? "")
//
//        self.login = "@" + (decoderData.userName ?? "")
//        self.bio = decoderData.bio
//    }
//
//struct ProfileResult: Codable {
//    let userName, firstName, lastName, bio: String?
//
//    enum CodingKeys: String, CodingKey {
//        case userName = "username"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case bio = "bio"
//    }
//}
//    private enum CodingKeysForProfileResult: String, CodingKey {
//        case userName = "user_name"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case bio
//
//    }
//}
