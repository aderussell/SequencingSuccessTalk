//
//  RecursiveSequenceTests.swift
//  
//
//  Created by Adrian Russell on 20/02/2024.
//

import XCTest
@testable import SequencingSuccessTalk

final class RecursiveSequenceTests: XCTestCase {

    let r = RecursiveType(name: "0", children: [
        RecursiveType(name: "0.0", children: [
            RecursiveType(name: "0.0.0", children: []),
            RecursiveType(name: "0.0.1", children: [
                RecursiveType(name: "0.0.1.0", children: []),
                RecursiveType(name: "0.0.1.1", children: []),
            ]),
            RecursiveType(name: "0.0.2", children: [])
        ]),
        RecursiveType(name: "0.1", children: [
            RecursiveType(name: "0.1.0", children: []),
            RecursiveType(name: "0.1.1", children: [
                RecursiveType(name: "0.1.1.0", children: []),
                RecursiveType(name: "0.1.1.1", children: []),
            ]),
            RecursiveType(name: "0.1.2", children: [])
        ])
    ])
    let r1 = RecursiveType(name: "1", children: [
        RecursiveType(name: "1.0", children: [
            RecursiveType(name: "1.0.0", children: []),
            RecursiveType(name: "1.0.1", children: [
                RecursiveType(name: "1.0.1.0", children: []),
                RecursiveType(name: "1.0.1.1", children: []),
            ]),
            RecursiveType(name: "1.0.2", children: [])
        ]),
        RecursiveType(name: "1.1", children: [
            RecursiveType(name: "1.1.0", children: []),
            RecursiveType(name: "1.1.1", children: [
                RecursiveType(name: "1.1.1.0", children: []),
                RecursiveType(name: "1.1.1.1", children: []),
            ]),
            RecursiveType(name: "1.1.2", children: [])
        ])
    ])
    
    func testWithInputSequence() throws {
        
    }

}
