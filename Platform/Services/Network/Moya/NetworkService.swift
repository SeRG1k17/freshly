//
//  NetworkService.swift
//  Platform
//
//  Created by Sergey Pugach on 7.05.21.
//

import Moya
import RxSwift
import Common

public final class NetworkService {

    private let provider: MoyaProvider<NetworkServiceEndpoint>

    public private(set) var plugins: [PluginType] = {
        return [
            NetworkLoggerPlugin(),
            NetworkActivityPlugin(networkActivityClosure: { (changeType: NetworkActivityChangeType, target: TargetType) in
            })
        ]
    }()

    public init() {
        
        let isTesting = ProcessInfo.processInfo.arguments.contains(LaunchArgument.testing.rawValue)
        
        self.provider = MoyaProvider<NetworkServiceEndpoint>(
            stubClosure: isTesting ? MoyaProvider.immediatelyStub: MoyaProvider.neverStub,
            plugins: plugins
        )
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
