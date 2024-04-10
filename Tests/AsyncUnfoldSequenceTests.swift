//
//  AsyncUnfoldSequenceTests.swift
//  
//
//  Created by Adrian Russell on 26/03/2024.
//

import XCTest
import SequencingSuccessTalk

fileprivate func throwingAdd(_ v: Int) throws -> Int { v + 1 }

final class AsyncUnfoldSequenceTests: XCTestCase {

    func testExample() async {
        for await element in asyncSequence(first: 0, next: { $0 + 1 }).prefix(10) {
            print(element)
        }
    }
    
    func testExample_throwing() async throws {
        for try await element in asyncSequence(first: 0, next: { try throwingAdd($0) }).prefix(10) {
            print(element)
        }
    }
}
