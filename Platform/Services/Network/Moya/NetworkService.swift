//
//  NetworkService.swift
//  Platform
//
//  Created by Sergey Pugach on 7.05.21.
//

import Moya
import RxSwift

public final class NetworkService {

    private let provider: MoyaProvider<NetworkServiceEndpoint>

    public private(set) static var plugins: [PluginType] = {
        return [
            NetworkLoggerPlugin(),
            NetworkActivityPlugin(networkActivityClosure: { (changeType: NetworkActivityChangeType, target: TargetType) in
            })
        ]
    }()

    public init(provider: MoyaProvider<NetworkServiceEndpoint> = MoyaProvider(plugins: NetworkService.plugins)) {
        self.provider = provider
    }
}


// MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {

    public func request<T: Decodable>(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue? = nil) -> Single<T> {
        return provider.rx
            .request(endpoint, callbackQueue: callbackQueue)
            .map(T.self)
            .mapErrorTo(NetworkServiceError.self)
    }

    public func request(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue?) -> Single<Response> {
        return provider.rx
            .request(endpoint, callbackQueue: callbackQueue)
            .mapErrorTo(NetworkServiceError.self)
    }

    public func requestCompletable(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue?) -> Completable {
        return provider.rx
            .request(endpoint, callbackQueue: callbackQueue)
            .mapErrorTo(NetworkServiceError.self)
            .asCompletable()
    }

    public func requestWithProgress(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        return provider.rx
            .requestWithProgress(endpoint, callbackQueue: callbackQueue)
            .mapErrorTo(NetworkServiceError.self)
    }

}
