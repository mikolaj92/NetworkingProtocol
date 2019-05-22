//
//  HTTPHeaders.swift
//  NetworkingProtocol
//
//  Created by Patryk Mikolajczyk on 2/1/19.
//  Copyright © 2019 BSG. All rights reserved.
//

import Foundation

public protocol HTTPHeaders {
    var headers: [String: String] { get }
}
