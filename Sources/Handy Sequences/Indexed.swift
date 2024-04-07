//
//  Indexed.swift
//

/// A collection wrapper that iterates over the indices and elements of a collection together.
/// It can be considered analagous to the `enumerated()` sequence
/// but returning the actual index of the collection rather than the 0-indexed interger position through the sequence.
///
/// This is based upon the `IndexedCollection` from the Swift Algorithms package.
public struct ARIndexedCollection<Base: Collection> {
    /// The base collection.
    @usableFromInline
    internal let base: Base
    
    @inlinable
    internal init(base: Base) {
        self.base = base
    }
}

extension ARIndexedCollection: Collection {
    public typealias Element = (index: Base.Index, element: Base.Element)
  
    @inlinable
    public var startIndex: Base.Index {
        base.startIndex
    }
  
    @inlinable
    public var endIndex: Base.Index {
        base.endIndex
    }
  
    @inlinable
    public subscript(position: Base.Index) -> Element {
        (index: position, element: base[position])
    }
  
    @inlinable
    public func index(after i: Base.Index) -> Base.Index {
        base.index(after: i)
    }
  
    @inlinable
    public func index(_ i: Base.Index, offsetBy distance: Int) -> Base.Index {
        base.index(i, offsetBy: distance)
    }
  
    @inlinable
    public func index(
        _ i: Base.Index,
        offsetBy distance: Int,
        limitedBy limit: Base.Index
    ) -> Base.Index? {
        base.index(i, offsetBy: distance, limitedBy: limit)
    }
  
    @inlinable
    public func distance(from start: Base.Index, to end: Base.Index) -> Int {
        base.distance(from: start, to: end)
    }
  
    @inlinable
    public var indices: Base.Indices {
        base.indices
    }
}

extension ARIndexedCollection: BidirectionalCollection where Base: BidirectionalCollection {
  @inlinable
  public func index(before i: Base.Index) -> Base.Index {
    base.index(before: i)
  }
}

extension ARIndexedCollection: RandomAccessCollection where Base: RandomAccessCollection {}

extension ARIndexedCollection: LazySequenceProtocol, LazyCollectionProtocol where Base: LazySequenceProtocol {}
