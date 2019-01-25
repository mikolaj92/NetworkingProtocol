//
//  CodableUtilitiesTests.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import XCTest
@testable import NetworkingProtocol

private struct ValidStruct: Codable, Equatable {
    let greeting: String
    let instructions: [String]
}

private struct InvalidStruct: Codable, Equatable {
    let greetings: String
    let instruction: [String]
    let invalidValue: Float = Float.nan
}

final class CodableUtilitiesTests: XCTestCase {
    let json =
    """
        {
        "greeting": "Hi!",
        "instructions": [
        "T1",
        "T2",
        "T3"
        ]
        }
        """

    func testDecoder() {
        XCTAssertThrowsError(try json.data(using: .utf8)?.decode(InvalidStruct.self))
        XCTAssertNoThrow(try json.data(using: .utf8)?.decode(ValidStruct.self))
    }

    func testEncoder() {
        let tester = ValidStruct(
            greeting: "Hi!",
            instructions: ["T1", "T2", "T3"]
        )

        let invalidStruct = InvalidStruct(greetings: "ed", instruction: [])

        XCTAssertNotNil(tester.encoded)
        XCTAssertNil(invalidStruct.encoded)
    }
}

