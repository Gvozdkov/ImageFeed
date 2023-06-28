import Foundation

// MARK: - class ImagesListService
final class ImagesListService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    static let shared = ImagesListService()
    private let token = OAuth2TokenStorage.shared
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    
    // MARK: - lifestyle
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = lastLoadedPage == nil ? 1 : nextPage
        
        var request = URLRequest(url: URL(string: "/photos?page=\(nextPage)&&per_page=10", relativeTo: APIConstants.baseURL)!)
        request.httpMethod = "GET"
        
        let token = token.token!
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let photoResult):
                    let _ = photoResult.map {
                        Photo(photoResult: $0) }
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": self.photos])
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
        }
        task.resume()
    }
}

// MARK: - extension
extension ImagesListService {
    func changeLike(photoId: String, isLike: Bool, indexPath: Int, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: "/photos/\(photoId)/like", relativeTo: APIConstants.baseURL) ?? URL(string: "https://unsplash.com")!)
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        guard let token = token.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                self.photos[indexPath].isLiked = photoResult.photo.isLiked
                completion(.success(Photo(photoResult: photoResult.photo)))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
