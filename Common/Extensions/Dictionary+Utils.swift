//
//  Dictionary+Utils.swift
//  Common
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation

extension Dictionary {

    public func mapKey<K: Hashable>(uniqueKeyTransform: (Key) throws -> K?) rethrows -> [K: Value] {
        return [K: Value](uniqueKeysWithValues: try transformedPairs(uniqueKeyTransform))
    }

    public func mapKey<K: Hashable>(transform: (Key) throws -> K?) rethrows -> [K: Value] {
        return [K: Value](try transformedPairs(transform)) { _, new in new }
    }

    private func transformedPairs<K: Hashable>(_ transform: (Key) throws -> K?) rethrows -> [(K, Value)] {

        return try map { (try transform($0), $1) }
            .compactMap { key, value -> (K, Value)? in
                guard let key = key else {
                    return nil
                }
                return (key, value)
        }
    }
}
