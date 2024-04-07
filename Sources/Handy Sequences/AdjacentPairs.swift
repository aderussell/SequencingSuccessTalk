//
//  AdjacentPairs.swift
//

import Foundation

struct ARAdjacentPairsSequence<Base: Sequence>: Sequence {
    internal let base: Base
    
    struct Iterator: IteratorProtocol {
        typealias Element = (Base.Element, Base.Element)
        
        internal var base: Base.Iterator
        internal var last: Base.Element?
        
        mutating func next() -> Element? {
            guard let last = self.last, let item = base.next() else { return nil }
            self.last = item
            return (last, item)
        }
    }
    
    func makeIterator() -> Iterator {
        var iterator = base.makeIterator()
        let firstElement = iterator.next()
        return Iterator(base: iterator, last: firstElement)
    }
}

extension Sequence {
    func adjacentPairs() -> ARAdjacentPairsSequence<Self> {
        ARAdjacentPairsSequence(base: self)
    }
}
