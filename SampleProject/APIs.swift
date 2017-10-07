import Foundation
import ReactiveCocoa
import Moya
import Alamofire

protocol APIType {
    var addXAuth: Bool { get }
}

enum APIs {
    case photosList(searchQuery: String, page: Int, perPage: Int)
    case fetchImage(serverID: String, secret: String, imageID: String)
}

extension APIs : TargetType, APIType {
    var headers: [String : String]? {
        return APIKeys.sharedKeys.defaultHTTPHeaders
    }

    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }

    var path: String {
        switch self {
        case .photosList( _, _, _):
            return "/services/rest"
            
        case .fetchImage(let serverID, let secret, let imageID):
            return "/\(serverID)/\(imageID)_\(secret).jpg"  //https://farm5.static.flickr.com/4216/35030306426_82211e574e.jpg
        }
    }

    var base: String {
        switch self {
        case .fetchImage(_, _, _):
            return Config.FLICKRURL
        default:
            return Config.SERVER_URL
        }
    }
    var baseURL: URL { return URL(string: base)! }

    var parameters: [String: Any]? {
        switch self {

        case .photosList(let query, let page, let perPage):
            return [
                "method": "flickr.photos.search",
                "api_key": Config.FLICKRAPIKEY,
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": query,
                "page": page,
                "per_page": perPage
            ]
        default:
            return nil
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var addXAuth: Bool {
        return false
    }
    
    func url() -> URL {
        return self.baseURL.appendingPathComponent(self.path)
    }
}

// MARK: - Provider support
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
