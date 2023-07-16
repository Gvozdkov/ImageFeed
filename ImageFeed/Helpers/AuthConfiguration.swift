import Foundation

struct APIConstants {
    static let accessKey = "gHfk4CwFAJjd8aUgeyp6rtgehb7EHphx7gWB_jGHF2k"
    static let secretKey = "mVsxJp385ah9ayKunt2NiXyS1CbUUxDE4zyQvb3mdlw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let defaultCode = "code"
    static let baseURL = URL(string: "https://unsplash.com")!
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authorizationPath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    let code: String
    let authorizationPath: String
    let baseURL: URL
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: APIConstants.accessKey,
                                 secretKey: APIConstants.secretKey,
                                 redirectURI: APIConstants.redirectURI,
                                 accessScope: APIConstants.accessScope,
                                 defaultBaseURL: APIConstants.defaultBaseURL,
                                 authURLString: APIConstants.authorizeURLString,
                                 
                                 code: APIConstants.defaultCode,
                                 authorizationPath: APIConstants.authorizationPath,
                                 baseURL: APIConstants.baseURL)
    }
}
