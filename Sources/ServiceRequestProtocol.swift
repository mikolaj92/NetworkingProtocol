//
//  ServiceRequest.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation


public protocol ServiceRequestProtocol {
    var urlScheme: String { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
    var allowsCellularAccess: Bool { get }
    var httpMethod: HTTPMethod { get }
    var headers: Headers? { get }
    var httpBody: Data? { get }
    var parameters: RequestParameters? { get }
}
extension ServiceRequestProtocol {
    public var urlScheme: String {
        return "https"
    }

    public var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.returnCacheDataElseLoad
    }

    public var timeoutInterval: TimeInterval {
        return 10
    }

    public var allowsCellularAccess: Bool {
        return true
    }

    public var httpMethod: HTTPMethod {
        return HTTPMethod.get
    }

    public var headers: Headers? {
        return nil
    }

    public var httpBody: Data? {
        guard let params = parameters else {
            return nil
        }
        switch params {
        case .json(let val):
            return val.encoded
        case .string(let val):
            return val.data(using: context.stringEncoding)
        case .urlEncoded:
            return nil
        }
    }

    public var parameters: RequestParameters? {
        return nil
    }

    private var url: URL {
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = urlHost
        components.path = urlPath
        var items: [URLQueryItem] = []
        if let params = parameters,
            case let .urlEncoded(value) = params {
            for (key, value) in value {
                items.append(URLQueryItem(name: key, value: value))
            }
            components.queryItems = items
        }
        guard let complete = components.url else {
            print(components)
            fatalError()
        }
        return complete
    }

    public var request: URLRequest {
        var req = URLRequest(url: url)
        req.cachePolicy = cachePolicy
        req.timeoutInterval = timeoutInterval
        req.allowsCellularAccess = allowsCellularAccess
        req.httpMethod = httpMethod.rawValue
        req.allHTTPHeaderFields = headers?.headers
        req.httpBody = httpBody
        return req
    }
}


extension ServiceRequestProtocol {
    public var curlString: String {
        var baseCommand = "curl \(url.absoluteString)"
        if httpMethod == .head {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        if httpMethod != .get && httpMethod != .head {
            command.append("-X \(httpMethod.rawValue)")
        }

        if let headers = headers?.headers {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody,
            let body = String(data: data, encoding: context.stringEncoding) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
