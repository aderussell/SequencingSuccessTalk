//
//  Windowed.swift
//

import Foundation

public struct ARWindowedSequence<Base: Sequence>: Sequence {
    internal let _base: Base
    internal let _count: Int
    
    init(_ base: Base, count: Int) {
        _base = base
        _count = count
    }
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = [Base.Element]
        internal var base: Base.Iterator
        internal var buffer: Element
        
        public mutating func next() -> Element? {
            guard let nextItem = base.next() else { return nil }
            var buffer = self.buffer
            buffer.append(nextItem)
            let i = buffer.dropFirst()
            self.buffer = Array(i)
            return buffer
        }
    }
    
    public func makeIterator() -> Iterator {
        var iterator = _base.makeIterator()
        var buffer: [Base.Element] = []
        for _ in 0..<_count-1 {
            if let item = iterator.next() {
                buffer.append(item)
            }
        }
        return Iterator(base: iterator, buffer: buffer)
    }
}

extension Sequence {
    public func windows(ofCount count: Int) -> ARWindowedSequence<Self> {
        ARWindowedSequence(self, count: count)
    }
}
