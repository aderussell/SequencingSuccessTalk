//
//  Chunked.swift
//

import Foundation

struct ARChunkedSequence<Base: Sequence>: Sequence {
    internal let base: Base
    internal let count: Int
    
    struct Iterator: IteratorProtocol {
        typealias Element = [Base.Element]
        
        internal var base: Base.Iterator
        internal let count: Int
        
        mutating func next() -> Element? {
            var remaining = count
            var items: [Base.Element] = []
            items.reserveCapacity(remaining)
            while remaining > 0, let item = base.next() {
                items.append(item)
                remaining -= 1
            }
            return items.isEmpty ? nil : items
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), count: count)
    }
}

extension Sequence {
    func chunked(ofCount count: Int) -> ARChunkedSequence<Self> {
        ARChunkedSequence(base: self, count: count)
    }
}
