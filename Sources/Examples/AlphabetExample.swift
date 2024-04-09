//
//  AlphabetExample.swift
//

import Foundation

/// A very simple Collection which returns all the letters of the lower-case Roman alphabet, each as a `Character`.
///
/// Note that in this example, the `Element` and `Index` are now different types.
/// The `Index` is still an `Int` as it is an ordered, linear sequence
/// but the `Element`is a `Character` for each of the letters.
public struct AlphabetCollection: Collection {
    public typealias Element = Character
    public typealias Index = Int
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { 26 }
    
    public subscript(position: Int) -> Character {
        Character(UnicodeScalar(position + 97)!)
    }
    
    public func index(after i: Int) -> Int {
        assert(i < endIndex, "Index out of range")
        return i + 1
    }
}

extension AlphabetCollection: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        assert(i > startIndex, "Index out of range")
        return i - 1
    }
}

extension AlphabetCollection: RandomAccessCollection {}
