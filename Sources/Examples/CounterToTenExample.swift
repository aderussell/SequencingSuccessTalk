//
//  CounterToTenExample.swift
//

import Foundation

/// A very simple iterator example which will count through the integers from 0-9 inclusive.
public struct CounterToTenIterator: IteratorProtocol {
    public typealias Element = Int
    private var val = 0
    
    public init() { }
    
    public mutating func next() -> Self.Element? {
        guard val < 10 else { return nil }
        val += 1
        return val
    }
}

/// A sequence which uses the `CounterToTenIterator`.
/// This sequence can be used with a for loop or with any the extension methods for Sequence, such as map/filter/reduce.
///
/// As a Sequence it can be iterated over but does not expose the ability to get a single value (or range of values by index).
public struct CounterToTenSequence: Sequence {
    public typealias Element = Int
    public typealias Iterator = CounterToTenIterator
    
    public init() { }
    
    public func makeIterator() -> CounterToTenIterator {
        CounterToTenIterator()
    }
}

/// Make `CounterToTenSequence` conform to `Collection`.
///
/// It is now possible to access value for a specified index.
/// Note that, in this example, the index is the name as the value as the collection is a linear sequence of Integers.
extension CounterToTenSequence: Collection {
    public typealias Index = Int
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { 10 }
    
    public subscript(position: Int) -> Int {
        get { position }
    }
    
    public func index(after i: Index) -> Index {
        assert(i < endIndex, "Index out of range")
        return i + 1
    }
}

/// Make `CounterToTenSequence` conform to `BidirectionalCollection`.
/// This is done by implementing the `index(before:)` method which returns the index before the specified parameter.
/// This allows the sequence to be iterated backwards in linear time.
extension CounterToTenSequence: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        assert(i > startIndex, "Index out of range")
        return i - 1
    }
}

/// Nothing is needed here for the sequence to conform to `RandomAccessCollection`
/// as the `Index` type (`Int`) conforms to `Strideable`
/// so the distance between elements can be calculated in constant time O(1).
///
/// If the `Index` did not conform to `Strideable` then we would need to implement
/// `index(_:offsetBy:)` and `distance(from:to:)` to be constant time.
extension CounterToTenSequence: RandomAccessCollection { }
