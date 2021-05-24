//
//  NetworkServiceMock.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 23.05.21.
//

import RxSwift
@testable import Platform

class NetworkServiceMock: NetworkServiceProtocol {
    
    let requestSubject = PublishSubject<Result<Data, Error>>()
    func request<T>(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue?) -> Single<T> where T : Decodable {
        requestSubject.fromResult().takeAsSingle()
            .map({ try JSONDecoder().decode(T.self, from: $0) })
    }
}
