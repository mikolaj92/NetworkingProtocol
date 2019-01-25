//
//  Data+JSONDecoder.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public extension Data {
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try JSONDecoder.current.decode(type, from: self)
    }
}
