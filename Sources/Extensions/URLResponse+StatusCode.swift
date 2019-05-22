//
//  URLResponse+StatusCode.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public extension URLResponse {
    var httpCode: Int? {
        return (self as? HTTPURLResponse)?.statusCode
    }
}
