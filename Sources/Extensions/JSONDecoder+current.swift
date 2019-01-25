//
//  JSONDecoder+current.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static let current: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = context.dateDecodingStrategy
        return decoder
    }()
}
