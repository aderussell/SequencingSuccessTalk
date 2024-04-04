//
//  FileReaderTests.swift
//  
//
//  Created by Adrian Russell on 04/04/2024.
//

import XCTest
import SequencingSuccessTalk

final class FileReaderTests: XCTestCase {

    func testUnfoldSequenceVersion() throws {
        let url = URL(filePath: "/usr/share/dict/words")
        let words = readLines(ofFile: url)
            .lazy
            .filter { $0.hasPrefix("ade") && $0.count > 6 }
            .map { $0.capitalized }
            .prefix(6)
        XCTAssertEqual(Array(words), ["Adelarthrosomatous", "Adeling", "Adelite", "Adelocerous", "Adelocodonic", "Adelomorphic"])
    }
    
    func testCustomIteratorVersion() throws {
        let url = URL(filePath: "/usr/share/dict/words")
        let words = FileReaderSequence(fileURL: url)
            .lazy
            .filter { $0.hasPrefix("ade") && $0.count > 6 }
            .map { $0.capitalized }
            .prefix(6)
        XCTAssertEqual(Array(words), ["Adelarthrosomatous", "Adeling", "Adelite", "Adelocerous", "Adelocodonic", "Adelomorphic"])
    }
}
