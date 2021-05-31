//
//  UserDefaultsProtocol.swift
//  Platform
//
//  Created by Sergey Pugach on 31.05.21.
//

import Foundation

public protocol UserDefaultsProtocol {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
}

extension UserDefaults: UserDefaultsProtocol {}
