//
//  ServiceRequestProtocolTests.swift
//  NetworkingProtocol
//
//  Created by Patryk Mikolajczyk on 1/28/19.
//  Copyright © 2019 BSG. All rights reserved.
//

import Foundation

import XCTest
@testable import NetworkingProtocol

final class ServiceRequestProtocolTests: XCTestCase {
    private enum Constants {
        static let baseURL = "jsonplaceholder.typicode.com"
        static let userId = 1
    }
    
    private struct PostRequest: ServiceRequestProtocol {
        let urlHost: String = Constants.baseURL
        let urlPath: String = "/posts"
        let httpMethod: HTTPMethod = .post
        let parameters: RequestParameters? = .json(PostParams(userId: 1))
    }
    
    private struct PostParams: Codable, Equatable {
        let userId: Int
    }
    
    func testGetRequest() {
        let request = GetRequest(userId: Constants.userId).request
        XCTAssertEqual(request.url, URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(Constants.userId)"))
    }
    
    func testGetCurl() {
        let request = GetRequest(userId: Constants.userId)
        XCTAssertEqual(request.curlString, "curl https://jsonplaceholder.typicode.com/posts?userId=\(Constants.userId)")
    }
    
    func testPostRequest() {
        let request = PostRequest().request
        XCTAssertEqual(request.url, URL(string: "https://jsonplaceholder.typicode.com/posts"))
        XCTAssertEqual(request.httpBody, PostParams(userId: Constants.userId).encoded)
    }
    
    func testPostCurl() {
        let request = PostRequest()
        let curl = request.curlString
        XCTAssertTrue(curl.contains("curl https://jsonplaceholder.typicode.com/posts"))
        XCTAssertTrue(curl.contains("-d '{\"userId\":1}'"))
        XCTAssertTrue(curl.contains("-X POST"))
    }
}
