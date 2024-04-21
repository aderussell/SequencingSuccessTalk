//
//  AsyncExtensions.swift
//

import Foundation

public struct AsyncEnumeratedSequence<Base: AsyncSequence>: AsyncSequence {
    public typealias Element = Iterator.Element
    internal let _base: Base
    
    public struct Iterator: AsyncIteratorProtocol {
        public typealias Element = (Int, Base.Element)
        internal var _base: Base.AsyncIterator
        internal var idx: Int = 0
        
        public mutating func next() async throws -> Element? {
            let value = try await _base.next()
            guard let value else { return nil }
            defer { idx += 1 }
            return (idx, value)
        }
    }
    
    public func makeAsyncIterator() -> Iterator {
        Iterator(_base: _base.makeAsyncIterator())
    }
}


extension AsyncSequence {
    public func enumerated() -> AsyncEnumeratedSequence<Self> {
        AsyncEnumeratedSequence(_base: self)
    }
}


extension AsyncSequence {
    public func forEach(_ body: (Self.Element) async throws -> Void) async rethrows {
        for try await element in self {
            try await body(element)
        }
    }
}


extension AsyncSequence {
    public func collect<Collected: RangeReplaceableCollection>(into: Collected.Type) async rethrows -> Collected where Collected.Element == Self.Element {
        try await reduce(into: Collected()) { $0.append($1) }
    }
    
    public func collect() async rethrows -> [Element] {
        try await collect(into: Array<Element>.self)
    }
}

