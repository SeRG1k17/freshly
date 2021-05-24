//
//  NetworkServiceProtocol.swift
//  Platform
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation
import RxSwift

public protocol NetworkServiceProtocol {

    func request<T: Decodable>(_ endpoint: NetworkServiceEndpoint, callbackQueue: DispatchQueue?) -> Single<T>
}

extension NetworkServiceProtocol {

    func request<T: Decodable>(_ endpoint: NetworkServiceEndpoint) -> Single<T> {
        return request(endpoint, callbackQueue: nil)
    }
}

