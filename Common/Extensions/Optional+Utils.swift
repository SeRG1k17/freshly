//
//  Optional+Utils.swift
//  Common
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation


extension Optional where Wrapped == Bool {

    static prefix func !(value: Wrapped?) -> Bool {
        return value.map({ !$0 }) ?? false
    }
}


extension Optional where Wrapped == String {

    /// Gets a value if the string is empty. If the value is `nil`, then the function will return `false`, because `nil` means that the string cannot be empty.
    ///
    /// - returns: Bool value
    var isEmpty: Bool {
        return map {
            $0.isEmpty
        } ?? false
    }
}


extension Optional {

    var isNil: Bool {
        return self == nil
    }

    var isNotNil: Bool {
        return self != nil
    }
}

