//
//  StorageServiceProtocol.swift
//  Platform
//
//  Created by Sergey Pugach on 31.05.21.
//

import RxSwift

public protocol StorageServiceProtocol {
    func get<T: Decodable, K: Hashable>(for key: K, with decoder: JSONDecoder) -> Single<T>
    func set<T: Encodable, K: Hashable>(value: T, for key: K, with encoder: JSONEncoder) -> Completable
    func listen<T: Decodable, K: Hashable>(for key: K) -> Observable<T>
}

extension StorageServiceProtocol {
    func get<T: Decodable, K: Hashable>(for key: K) -> Single<T> {
        get(for: key, with: JSONDecoder())
    }
    
    func set<T: Encodable, K: Hashable>(value: T, for key: K) -> Completable {
        set(value: value, for: key, with: JSONEncoder())
    }
}
