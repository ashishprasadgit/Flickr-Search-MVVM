import Foundation
import Moya
import ReactiveCocoa
import ReactiveSwift
import Alamofire

import enum Result.NoError

class OnlineProvider<Target> where Target: Moya.TargetType {

    fileprivate let online: SignalProducer<Bool, NoError>
    fileprivate let provider: MoyaProvider<Target>

    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false,
        online: SignalProducer<Bool, NoError> = connectedToInternetOrStubbing()) {

        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }

    func request(_ token: Target) -> SignalProducer<Moya.Response, MoyaError> {
        let actualRequest = provider.reactive.request(token)
        return actualRequest
        
//        return online
////            .skip(while: { ($0 == false) })
////            .take(first: 1)
//            .flatMap(.latest, { _ in
//                return actualRequest
//            })
//
    }
    
    func requestWithProgress(_ token: Target) -> SignalProducer<ProgressResponse, MoyaError> {
        return provider.reactive.requestWithProgress(token)
    }
}

protocol NetworkingType {
    associatedtype T: TargetType, APIType
    var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = APIs
    let provider: OnlineProvider<APIs>
}

// "Public" interfaces
extension Networking {
    func request(_ token: APIs, defaults: UserDefaults = UserDefaults.standard) -> SignalProducer<Moya.Response, MoyaError> {
        return self.provider.request(token)
    }
    
    func requestWithProgress(_ token: APIs, defaults: UserDefaults = UserDefaults.standard) -> SignalProducer<ProgressResponse, MoyaError> {
        return self.provider.requestWithProgress(token)
    }
}

// Static methods
extension NetworkingType {
    static func newDefaultNetworking() -> Networking {
        return Networking(provider: newProvider(plugins))
    }
    
    static func backgroundNetworking() -> Networking {
        return Networking(provider: newBackgroundProvider(plugins))
    }
    
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint<T> where T: TargetType, T: APIType {
        return { target in
            let endpoint: Endpoint<T> = Endpoint<T>(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
            return endpoint
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never // APIKeys.sharedKeys.stubResponses ? .immediate :
    }

    static var plugins: [PluginType] {
        return [NetworkLogger(whitelist: { target -> Bool in
            guard let _ = target as? APIs else { return false }
            return true
        })
        ]
    }

    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
        return { (endpoint, closure) in
            var request = endpoint.urlRequest!
            request.httpShouldHandleCookies = false
            closure(.success(request))
        }
    }
}

private func newBackgroundProvider<T>(_ plugins: [PluginType], xAccessToken: String? = nil) -> OnlineProvider<T> where T: APIType {
    let configuration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier!)
    let manager = Manager(configuration: configuration)

    return OnlineProvider(endpointClosure: Networking.endpointsClosure(xAccessToken),
                          requestClosure: Networking.endpointResolver(),
                          stubClosure: Networking.APIKeysBasedStubBehaviour,
                          manager: manager,
                          plugins: plugins)
}


private func newProvider<T>(_ plugins: [PluginType], xAccessToken: String? = nil) -> OnlineProvider<T> where T: APIType {
    return OnlineProvider(endpointClosure: Networking.endpointsClosure(xAccessToken),
        requestClosure: Networking.endpointResolver(),
        stubClosure: Networking.APIKeysBasedStubBehaviour,
        plugins: plugins)
}
