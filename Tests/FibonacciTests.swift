//
//  FibonacciTests.swift
//  
//
//  Created by Adrian Russell on 22/02/2024.
//

import XCTest
@testable import SequencingSuccessTalk

final class FibonacciTests: XCTestCase {

    func testFibonacci_firstTen() throws {
        let content = Fibonacci().prefix(10).toArray()
        XCTAssertEqual(content, [0,1,1,2,3,5,8,13,21,34])
    }

}
