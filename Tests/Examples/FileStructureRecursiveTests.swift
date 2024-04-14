//
//  FileStructureRecursiveTests.swift
//  
//
//  Created by Adrian Russell on 14/04/2024.
//

import XCTest
import Algorithms
import SequencingSuccessTalk

final class FileStructureRecursiveTests: XCTestCase {
    
    func testFirst() {
        let value = RecursiveSequence(element: fileSystem, keyPath: \.children)
            .first(where: { $0.isFile && $0.name.hasSuffix("png") })
        XCTAssertEqual(value?.name, "Pic2.png")
    }
    
    func testFirstIndex() {
        let value = RecursiveSequence(element: fileSystem, keyPath: \.children)
            .firstIndex(where: { $0.isFile && $0.name.hasSuffix("png") })
        XCTAssertEqual(value, IndexPath(indexes: [0, 1, 1]))
    }
    
    func testFilter() {
        let images =  RecursiveSequence(element: fileSystem, keyPath: \.children)
            .filter { $0.isFile && $0.name.hasSuffix("png") }
            .map { $0.name }
        XCTAssertEqual(images, ["Pic2.png", "Mountain.png"])
    }
    
    func testIndexedFilter() {
        let images = RecursiveSequence(element: fileSystem, keyPath: \.children)
            .lazy
            .indexed()
            .filter { $1.isFile && $1.name.hasSuffix("png") }
            .map { $0.index }
            .toArray()
        XCTAssertEqual(images, [IndexPath(indexes: [0, 1, 1]), IndexPath(indexes: [0, 1, 2, 1])])
    }

    func testElementsAlongPath() {
        let sequence = RecursiveSequence(element: fileSystem, keyPath: \.children)
        let index = sequence
            .firstIndex(where: { $0.isFile && $0.name.hasSuffix("png") })!
        let names = sequence.elements(along: index)
            .map { $0.name }
        XCTAssertEqual(names, ["Root", "Pictures", "Pic2.png"])
    }
}
