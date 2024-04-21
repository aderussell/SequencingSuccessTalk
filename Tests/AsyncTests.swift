//
//  AsyncTests.swift
//  
//
//  Created by Adrian Russell on 21/04/2024.
//

import XCTest
import SequencingSuccessTalk
import AsyncAlgorithms

final class AsyncTests: XCTestCase {

    func testCollect() async throws {
        let result = await CounterToTenSequence().async.collect()
        XCTAssertEqual(result, [1,2,3,4,5,6,7,8,9,10])
    }
    
    func testAsyncEnumerated() async throws {
        let result = try await CounterToTenSequence().async.enumerated().collect()
        XCTAssertEqual(result.map({ $0.0 }), [0,1,2,3,4,5,6,7,8,9])
        XCTAssertEqual(result.map({ $0.1 }), [1,2,3,4,5,6,7,8,9,10])
    }
    
    func testAsyncForEach() async throws {
        let expected = [1,2,3,4,5,6,7,8,9,10]
        var callCount = 0
        try await CounterToTenSequence().async.enumerated()
            .forEach {
                XCTAssertEqual(expected[$0.0], $0.1)
                callCount += 1
            }
        XCTAssertEqual(callCount, 10)
    }
}
