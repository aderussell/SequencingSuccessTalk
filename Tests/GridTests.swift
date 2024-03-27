//
//  GridTests.swift
//  
//
//  Created by Adrian Russell on 23/03/2024.
//

import XCTest
import SequencingSuccessTalk

final class GridTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

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
    
    func test_windows() {
        let grid = Grid(elements: [[1,2,3,4],[5,6,7,8],[9,8,7,6],[0,2,3,4]])
        let windows = grid.windows(width: 2, height: 2)
        windows.forEach { print(Array($0)) }
    }
}
