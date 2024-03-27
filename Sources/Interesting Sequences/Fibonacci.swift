//
//  Fibonacci.swift
//

import Foundation

public struct Fibonacci: Sequence {
    public typealias Element = Int
    
    public init() {}
    
    public struct Iterator: IteratorProtocol {
        private var elements = (0,1)
        public mutating func next() -> Element? {
            defer { elements = (elements.1, elements.0 + elements.1) }
            return elements.0
        }
    }
    
    public func makeIterator() -> Iterator {
        Iterator()
    }
}



func fibonacci() -> some Sequence<Int> {
    sequence(state: (0, 1)) { (state) -> Int? in
        defer { state = (state.1, state.0 + state.1) }
        return state.0
    }
}
