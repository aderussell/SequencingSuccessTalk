//
//  DateStrideSequenceTests.swift
//  
//
//  Created by Adrian Russell on 21/04/2024.
//

import XCTest
import SequencingSuccessTalk

final class DateStrideSequenceTests: XCTestCase {
    
    func testStrideDateTo() throws {
        let start = Date(timeIntervalSince1970: 1713655782)
        let end   = Date(timeIntervalSince1970: 1714174182)
        let dates = strideDate(from: start, to: end, by: .days(1))
            .map { $0.timeIntervalSince1970 }
            .toArray()
        XCTAssertEqual(dates, [ 1713655782, 
                                1713742182,
                                1713828582,
                                1713914982,
                                1714001382,
                                1714087782 ])
    }
    
    func testStrideDateThrough() throws {
        let start = Date(timeIntervalSince1970: 1713655782)
        let end   = Date(timeIntervalSince1970: 1714174182)
        let dates = strideDate(from: start, through: end, by: .days(1))
            .map { $0.timeIntervalSince1970 }
            .toArray()
        XCTAssertEqual(dates, [ 1713655782,
                                1713742182,
                                1713828582,
                                1713914982,
                                1714001382,
                                1714087782,
                                1714174182 ])
    }
    
    func testStrideDateTo_backwards() throws {
        let start = Date(timeIntervalSince1970: 1713655782)
        let end   = Date(timeIntervalSince1970: 1714174182)
        let dates = strideDate(from: end, to: start, by: .days(-1))
            .map { $0.timeIntervalSince1970 }
            .toArray()
        XCTAssertEqual(dates, [ 1714174182,
                                1714087782,
                                1714001382,
                                1713914982,
                                1713828582,
                                1713742182 ])
    }
    
    func testStrideDateThrough_backwards() throws {
        let start = Date(timeIntervalSince1970: 1713655782)
        let end   = Date(timeIntervalSince1970: 1714174182)
        let dates = strideDate(from: end, through: start, by: .days(-1))
            .map { $0.timeIntervalSince1970 }
            .toArray()
        XCTAssertEqual(dates, [ 1714174182,
                                1714087782,
                                1714001382,
                                1713914982,
                                1713828582,
                                1713742182,
                                1713655782 ])
    }
}


