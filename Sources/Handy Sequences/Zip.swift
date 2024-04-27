//
//  Zip.swift
//

import Foundation

@available(macOS 14.0.0, *)
public struct ZipSequence<S1: Sequence, S2: Sequence, each S: Sequence>: Sequence {
    public typealias Element = (S1.Element, S2.Element, repeat (each S).Element)
    
    @usableFromInline internal let _sequence1: S1
    @usableFromInline internal let _sequence2: S2
    @usableFromInline internal let sequences: (repeat each S)
    
    @inlinable
    public func makeIterator() -> Iterator {
        return Iterator(
            _sequence1.makeIterator(),
            _sequence2.makeIterator(),
            (repeat (each sequences).makeIterator())
        )
    }
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = (S1.Element, S2.Element, repeat (each S).Element)
        
        @usableFromInline internal var _reachedEnd: Bool = false
        @usableFromInline internal var _iterator1: S1.Iterator
        @usableFromInline internal var _iterator2: S2.Iterator
        @usableFromInline var iterators: (repeat (each S).Iterator)
        
        @inlinable
        init(_ iterator1: S1.Iterator, _ iterator2: S2.Iterator, _ iterators: (repeat (each S).Iterator)) {
            self._iterator1 = iterator1
            self._iterator2 = iterator2
            self.iterators = iterators
        }
        
        public mutating func next() -> Element? {
            do {
                guard let item1 = _iterator1.next() else {
                    _reachedEnd = true
                    return nil
                }
                guard let item2 = _iterator2.next() else {
                    _reachedEnd = true
                    return nil
                }
                let iterVal = try (repeat nextFor(each iterators))
                iterators = (repeat (each iterVal).0)
                return (item1, item2, repeat (each iterVal).1)
            } catch {
                return nil
            }
        }
    }
    
    @inlinable
    public var underestimatedCount: Int {
        var length: Int = Swift.min(_sequence1.underestimatedCount, _sequence2.underestimatedCount)
        repeat length = Swift.min(length, (each sequences).underestimatedCount)
        return length
    }
}

/// Currently there is not a convenient way to inspect a parameter pack to determine if part of the pack is a nil by using `guard let` or similar.
/// Additionally the elements within a pack cannot be mutated.
/// To get around this, this method is used which will make a copy of the iterator and return it in a tuple to replace the older one.
/// It will also throw if an iterator has finished to allow for the zip iterator to end,
///
/// None of this is ideal but will hopefully be rectified in swift 6.0 and later.
/// https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
private func nextFor<I: IteratorProtocol>(_ iterator: I) throws -> (I, I.Element) {
    var iterator = iterator
    guard let value = iterator.next() else { throw IteratorError.noMoreElements }
    return (iterator, value)
}

private enum IteratorError: Error {
    case noMoreElements
}

@available(macOS 14.0.0, *)
public func zip<S1: Sequence, S2: Sequence, each S: Sequence>(_ first: S1, _ second: S2, _ seq: repeat each S) -> ZipSequence<S1, S2, repeat each S> {
    ZipSequence(_sequence1: first, _sequence2: second, sequences: (repeat each seq))
}
