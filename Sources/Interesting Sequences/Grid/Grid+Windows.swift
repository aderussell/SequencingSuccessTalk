//
//  Grid+Windows.swift
//

import Foundation

public struct GridWindowedSequence<T>: Sequence {
    internal let base: Grid<T>
    internal let width: Int
    internal let height: Int
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = GridSubSequence<T>
        internal var base: Grid<T>
        internal var width: Int
        internal var height: Int
        
        internal var x = 0
        internal var y = 0
        
        public mutating func next() -> Element? {
            guard y < base.height - height else { return nil }
            if x >= base.width - width {
                y += 1
                x = 0
            }
            defer { x += 1 }
            return base.subgrid(origin: .init(x: x, y: y), width: width, height: height)
        }
    }
    
    public func makeIterator() -> Iterator {
        Iterator(base: base, width: width, height: height)
    }
}

extension Grid {
    public func windows(width: Int, height: Int) -> GridWindowedSequence<T> {
        GridWindowedSequence(base: self, width: width, height: height)
    }
}
