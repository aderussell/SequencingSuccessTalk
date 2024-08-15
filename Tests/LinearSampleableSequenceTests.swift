//
//  LinearSampleableSequenceTests.swift
//

import XCTest
import SequencingSuccessTalk

final class LinearSampleableSequenceTests: XCTestCase {
    func testLinearSample() throws {
        let originalSequence: [Double] = [1,2,3,4,5]
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 3)
        XCTAssertEqual(Array(expanded), [1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.25, 3.5, 3.75, 4.0, 4.25, 4.5, 4.75, 5.0])
    }
    
    func testLinearSample_partialWiderSteps() throws {
        let originalSequence: [Double] = [1,3,4,6,7]
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 3)
        XCTAssertEqual(Array(expanded), [1.0, 1.5, 2.0, 2.5, 3.0, 3.25, 3.5, 3.75, 4.0, 4.5, 5.0, 5.5, 6.0, 6.25, 6.5, 6.75, 7.0])
    }
    
    func testLinearSample_noAdditional() throws {
        let originalSequence: [Double] = [1,2,3,4,5]
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 0)
        XCTAssertEqual(Array(expanded), [1.0, 2.0, 3.0, 4.0, 5.0])
    }
    
    func testLinearSample_singleAdditional() throws {
        let originalSequence: [Double] = [1,2,3,4,5]
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 1)
        XCTAssertEqual(Array(expanded), [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0])
    }
    
    func testLinearSample_emptyElement() throws {
        let originalSequence: [Double] = []
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 3)
        XCTAssertEqual(Array(expanded), [])
    }
    
    func testLinearSample_singleElement() throws {
        let originalSequence: [Double] = [1]
        let expanded = LinearSampleable(base: originalSequence, innerSampleCount: 3)
        XCTAssertEqual(Array(expanded), [1.0])
    }
}
