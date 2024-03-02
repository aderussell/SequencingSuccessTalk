//
//  RecursiveSequenceTests.swift
//  
//
//  Created by Adrian Russell on 20/02/2024.
//

import XCTest
@testable import SequencingSuccessTalk

final class RecursiveSequenceTests: XCTestCase {

    struct RecursiveType {
        var name: String
        var children: [RecursiveType]
    }
    
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
        let s1 = RecursiveSequence(element: r, keyPath: \.children)
        for thing in s1 {
            print(thing.name)
        }
        print("----------")
        let s2 = RecursiveSequence([r, r1], keyPath: \.children)
        for thing in s2 {
            print(thing.name)
        }
        print("----------")
        for thing in [r, r1].recursive(keyPath: \.children) {
            print(thing.name)
        }
    }

    
    func testWithInputSequence_bfs() throws {
        let s1 = BreadthFirstRecursiveSequence(element: r, keyPath: \.children)
        for thing in s1 {
            print(thing.name)
        }
        print("----------")
        let s2 = BreadthFirstRecursiveSequence([r, r1], keyPath: \.children)
        for thing in s2 {
            print(thing.name)
        }
        print("----------")
        for thing in [r, r1].recursive_bfs(keyPath: \.children) {
            print(thing.name)
        }
    }
}
