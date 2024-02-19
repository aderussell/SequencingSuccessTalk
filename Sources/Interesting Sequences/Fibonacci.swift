//
//  Fibonacci.swift
//

import Foundation

struct Fibonacci: Sequence {
    typealias Element = Int
    
    struct Iterator: IteratorProtocol {
        private var elements = [0,1]
        mutating func next() -> Element? {
            let result = elements[0]
            let next = elements.reduce(0, +)
            elements = [elements[1], next]
            return result
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator()
    }
}
