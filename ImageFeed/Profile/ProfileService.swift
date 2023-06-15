//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 15.06.2023.
//

import Foundation

struct ProfileResult: Codable {
    let userName, firstName, lastName, bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Decodable {
    let userName: String?
    let name: String?
    let bio: String?
    let login: String?
    
    init (decoderData: ProfileResult) {
        self.userName = decoderData.userName
        self.name = (decoderData.firstName ?? "") + " " + (decoderData.lastName ?? "")
        
        self.login = "@" + (decoderData.userName ?? "")
        self.bio = decoderData.bio
    }
    
    private enum CodingKeysForProfileResult: String, CodingKey {
        case userName = "user_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        
    }
}
