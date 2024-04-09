//
//  CounterToTenSequenceTests.swift
//  
//
//  Created by Adrian Russell on 09/04/2024.
//

import XCTest
import SequencingSuccessTalk

final class CounterToTenSequenceTests: XCTestCase {

    func textIterator() {
        var counter = CounterToTenIterator()
        while let value = counter.next() {
            print(value)
        }
    }

    func testSequence() throws {
        for element in CounterToTenSequence() {
            print(element)
        }
    }
}
