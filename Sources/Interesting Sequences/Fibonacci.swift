//
//  Fibonacci.swift
//

import Foundation

struct Fibonacci: Sequence {
    typealias Element = Int
    
    struct Iterator: IteratorProtocol {
        private var elements = (0,1)
        mutating func next() -> Element? {
            let result = elements.0
            let next = elements.0 + elements.1
            elements = (elements.1, next)
            return result
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator()
    }
}
