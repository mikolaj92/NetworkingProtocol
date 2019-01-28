//
//  ServiceProtocolTests.swift
//  NetworkingProtocol
//
//  Created by Patryk Mikolajczyk on 1/28/19.
//  Copyright © 2019 BSG. All rights reserved.
//

import XCTest
@testable import NetworkingProtocol

final class ServiceProtocolTests: XCTestCase {
    private struct Service: ServiceProtocol {
        var session: URLSessionProtocol = URLSession.init(configuration: .default)
    }
    
    private let service: Service = .init()
    private let request = GetRequest(userId: 1)
    func testDataTask() {
        let expectation = XCTestExpectation(description: "get data")
        let task = service.dataTask(withRequest: request) { (result: Result<[GetResponse]>) in
            switch result {
            case .value(let val):
                XCTAssertEqual(val, GetResponse.mocks)
            case .error(let err):
                XCTFail(err.localizedDescription)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(task.error)
        XCTAssertNotNil(task.response)
    }
}
