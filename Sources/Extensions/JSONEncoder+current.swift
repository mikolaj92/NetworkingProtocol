//
//  JSONEncoder+currebt.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

extension JSONEncoder {
    static let current: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = context.dateEncodingStrategy
        return encoder
    }()
}
