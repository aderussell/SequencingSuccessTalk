//
//  ZipTests.swift
//  
//
//  Created by Adrian Russell on 27/04/2024.
//

import XCTest
import SequencingSuccessTalk

final class ZipTests: XCTestCase {

    @available(macOS 14.0.0, *)
    func testExample() throws {
        let a = ["a", "b", "c", "d", "e"]
        let b = 1...10
        let c = stride(from: 0.0, to: 20.0, by: 2.5)
        let final = zip(a, b, c)
        print(final)
    }
}
