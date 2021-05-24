//
//  NetworkServiceEndpoint+Moya.swift
//  Platform
//
//  Created by Sergey Pugach on 11.05.21.
//

import Moya

public typealias Headers = [String: String]
public typealias Parameters = [String: Any]


extension NetworkServiceEndpoint: TargetType {

    public var baseURL: URL {
        return URL(string: "https://api.seatgeek.com/2")!
    }

    public var path: String {
        switch self {
        case .events:
            return "events"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var headers: Headers? {
        return [:]
    }

    public var task: Task {
        let parameters = ParameterKey.default
        switch self {
        case .events:
            return .requestParameters(
                parameters: parameters.mapKey(uniqueKeyTransform: { $0.rawValue }),
                encoding: URLEncoding.default
            )
        }
    }

    var urlString: String {
        return baseURL.appendingPathComponent(path).absoluteString
    }

    // MARK: - Stub

    public var sampleData: Data {
        return stubbedResponse() ?? Data()
    }
}


private extension NetworkServiceEndpoint {

    enum ParameterKey: String {
        case contentType = "Content-Type"
        case deviceId = "X-Device-Id"
        case osVersion = "X-OS-Version"
        case clientVersion = "X-Client-Version"
        case clientId = "client_id"
        static var `default`: [ParameterKey: String] {
            return [
                .clientId: "MjE3MTU3MjV8MTYxODQxMDMzNS44NzY4MDQ4"
            ]
        }
    }
}


private extension NetworkServiceEndpoint {

    enum FileExtension {
        case json, txt, doc
        case png, jpg, jpeg
        case swift

        var string: String {
            return String(describing: self)
        }
    }


    // Use properties for cases with specific filenames and extensions
    func stubbedResponse(_ filename: String? = nil, withExtension ext: FileExtension? = nil) -> Data? {

        let name = filename ?? String(describing: self).capitalizedFirstLetter
        let fileExtension = ext ?? .json

        guard
            let match = name.range(of: "^[\\w]*", options: .regularExpression),
            let file = Bundle.module.url(forResource: String(name[match]), withExtension: fileExtension.string),
            let data = try? Data(contentsOf: file) else {
            return Data()
        }

        return data
    }

}

