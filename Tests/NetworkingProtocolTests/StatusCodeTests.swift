//
//  StatusCodeTests.swift
//  NetworkingProtocol
//
//  Created by Patryk Mikolajczyk on 1/28/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import XCTest
@testable import NetworkingProtocol

final class StatusCodeTests: XCTestCase {

    private let statusCode = 200
    private let url = URL(string: "https://www.google.com/")!
    
    func testPositive() {
        
        let response: URLResponse? = HTTPURLResponse.init(url: url,
                                                          statusCode: statusCode,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        XCTAssertEqual(statusCode, response?.httpCode)
    }
    
    func testNegative() {
        let response = URLResponse(url: url,
                                   mimeType: nil,
                                   expectedContentLength: 100,
                                   textEncodingName: nil)
        XCTAssertNil(response.httpCode)
    }
}
