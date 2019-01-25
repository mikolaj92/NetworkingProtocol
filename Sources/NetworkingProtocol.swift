//
//  NetworkingProtocol.swift
//  mikolaj92
//
//  Created by Patryk Mikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public var context = Context()

private class NetworkProtocol {}

public struct Context {
    public var bundle = Bundle(for: NetworkProtocol.self)
    public var locale = Locale.current
    public var dateFormatter = ISO8601DateFormatter()
    public var stringEncoding = String.Encoding.utf8
    public var dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
    public var dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.iso8601
}
