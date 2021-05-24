//
//  NetworkServiceError.swift
//  Platform
//
//  Created by Sergey Pugach on 11.05.21.
//

import Common

public enum NetworkServiceError: MappableError {

    case mappingError

    case unknownError(message: String)

    public init(error: Error) {
        switch error {
        case let err as NetworkServiceError:
            self = err
        default:
            self = .unknownError(message: error.localizedDescription)
        }
    }
}
