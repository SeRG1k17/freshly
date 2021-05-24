//
//  StorageServiceMock.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 23.05.21.
//

import RxSwift
@testable import Platform

class StorageServiceMock: StorageServiceProtocol {
    
    let getSubject = PublishSubject<Result<Data, Error>>()
    func get<T, K>(for key: K, with decoder: JSONDecoder) -> Single<T> where T : Decodable, K : Hashable {
        getSubject.fromResult()
            .takeAsSingle()
            .map({ try JSONDecoder().decode(T.self, from: $0) })
    }
    
    let setSubject = PublishSubject<Result<Void, Error>>()
    func set<T, K>(value: T, for key: K, with encoder: JSONEncoder) -> Completable where T : Encodable, K : Hashable {
        setSubject.fromResult()
            .takeAsCompletable()
    }
    
    let listenSubject = PublishSubject<Result<Data, Error>>()
    func listen<T, K>(for key: K) -> Observable<T> where T : Decodable, K : Hashable {
        listenSubject.asObservable().fromResult()
            .map({ try JSONDecoder().decode(T.self, from: $0) })
    }
}
