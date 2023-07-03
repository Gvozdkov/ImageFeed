import Foundation

// MARK: - struct Photo
struct Photo {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

// MARK: - struct PhotoResult
struct PhotoResult: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: ImageUrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
        case width = "width"
        case height = "height"
    }
}

// MARK: - ImageUrlsResult
struct ImageUrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

// MARK: - struct LikePhotoResult
struct LikePhotoResult: Decodable {
    let photo: PhotoResult?
}

