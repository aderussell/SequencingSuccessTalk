//
//  AlphabetSequenceTests.swift
//  
//
//  Created by Adrian Russell on 22/05/2024.
//

import XCTest
import SequencingSuccessTalk

final class AlphabetSequenceTests: XCTestCase {

    func textIterator() {
        var counter = AlphabetIterator()
        while let value = counter.next() {
            print(value)
        }
    }

    func testSequence() throws {
        for element in AlphabetSequence() {
            print(element)
        }
    }

}
