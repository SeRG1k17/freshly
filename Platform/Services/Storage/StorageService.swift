//
//  StorageService.swift
//  Platform
//
//  Created by Sergey Pugach on 22.05.21.
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

public class StorageService {
    
    enum Error: Swift.Error {
        case keyMapping
        case dataMapping
    }
    
    private let changedSubject = PublishSubject<String>()
    private let storage: UserDefaults = UserDefaults.standard
    
    public init() {
    }
}

// MARK: - StorageServiceProtocol

extension StorageService: StorageServiceProtocol {
    
    public func get<T, K>(for key: K, with decoder: JSONDecoder) -> Single<T> where T : Decodable, K : Hashable {
        stringKey(from: key)
            .map({ [unowned self] (key: String) -> Data in
                guard let data = self.storage.value(forKey: key) as? Data else {
                    throw Error.dataMapping
                }
                return data
            })
            .map({ (data: Data) -> T in
                try T.decode(data: data, with: decoder)
            })
    }
    
    public func set<T, K>(value: T, for key: K, with encoder: JSONEncoder) -> Completable where T : Encodable, K : Hashable {
        stringKey(from: key)
            .map({ (key: String) -> (value: Data, key: String) in
                (try value.encode(with: encoder), key)
            })
            .do(onSuccess: { [weak self] (value: Data, key: String) in
                self?.storage.setValue(value, forKey: key)
                self?.changedSubject.onNext(key)
            })
            .asCompletable()
    }
    
    
    public func listen<T, K>(for key: K) -> Observable<T> where T : Decodable, K : Hashable {
        let mappedKey = stringKey(from: key)
            .asObservable()
            
        let changed = mappedKey
            .flatMapLatest({ [unowned self] (key: String) -> Observable<String> in
                self.changedSubject
                    .filter({ $0 == key })
            })
            
        return Observable.merge(
            mappedKey,
            changed
        )
            .flatMapLatest({ [unowned self] (key: String) -> Maybe<T> in
                self.get(for: key)
                    .asObservable()
                    .materialize()
                    .compactMap({ $0.element })
                    .asMaybe()
            })
    }
}

private extension StorageService {
    
    func stringKey<T: Hashable>(from key: T) -> Single<String> {
        Single.just(key)
            .map({ [unowned self] (key: T) -> String in
                try self.stringKey(from: key)
            })
    }
    
    func stringKey<T: Hashable>(from key: T) throws -> String {
        guard let keyString = key as? String else {
            throw Error.keyMapping
        }
        return keyString
    }
}

extension Decodable {
    
    static func decode(data: Data, with decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
}
