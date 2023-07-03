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
