//
//  GridTests.swift
//  
//
//  Created by Adrian Russell on 23/03/2024.
//

import XCTest
import SequencingSuccessTalk

final class GridTests: XCTestCase {

    func test_count() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        XCTAssertEqual(grid.count, 16)
    }
    
    
    func test_contains() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        XCTAssertFalse(grid.contains(12))
        XCTAssertTrue(grid.contains(2))
    }
    
    func test_usingFirstIndex() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let index = grid.firstIndex(of: 0)
        XCTAssertEqual(index, Point(x: 0, y: 3))
    }

    
    func test_subsequence() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let subgrid = grid.subgrid(origin: .init(x: 1, y: 1), width: 2, height: 3)
        XCTAssertEqual(Array(subgrid), [6,7,8,7,2,3])
    }
    
    func test_column() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let subgrid = grid.content(column: 1)
        XCTAssertEqual(Array(subgrid), [2,6,8,2])
    }
    
    func test_row() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let subgrid = grid.content(row: 1)
        XCTAssertEqual(Array(subgrid), [5,6,7,8])
    }
    
    func test_windows() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let windows = grid.windows(width: 2, height: 2)
        var iterator = windows.makeIterator()
        XCTAssertEqual(Array(iterator.next()!), [1, 2, 5, 6])
        XCTAssertEqual(Array(iterator.next()!), [2, 3, 6, 7])
        XCTAssertEqual(Array(iterator.next()!), [5, 6, 9, 8])
        XCTAssertEqual(Array(iterator.next()!), [6, 7, 8, 7])
        XCTAssertEqual(Array(iterator.next()!), [9, 8, 0, 2])
        XCTAssertNil(iterator.next())
    }
}
