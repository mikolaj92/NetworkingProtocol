//
//  Result.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public enum Result<T> {
    case value(T)
    case error(Error)
}

