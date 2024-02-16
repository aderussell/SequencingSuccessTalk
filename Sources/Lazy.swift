//
//  File.swift
//

import Foundation


struct ExampleLazyFilterSequence<Base: Sequence> {
    internal var _base: Base
    internal let _predicate: (Base.Element) -> Bool
}

extension ExampleLazyFilterSequence {
  /// An iterator over the elements traversed by some base iterator that also
  /// satisfy a given predicate.
  ///
  /// - Note: This is the associated `Iterator` of `LazyFilterSequence`
  /// and `LazyFilterCollection`.
  @frozen // lazy-performance
  public struct Iterator {
    /// The underlying iterator whose elements are being filtered.
    public var base: Base.Iterator { return _base }

    @usableFromInline // lazy-performance
    internal var _base: Base.Iterator
    @usableFromInline // lazy-performance
    internal let _predicate: (Base.Element) -> Bool

    /// Creates an instance that produces the elements `x` of `base`
    /// for which `isIncluded(x) == true`.
    @inlinable // lazy-performance
    internal init(_base: Base.Iterator, _ isIncluded: @escaping (Base.Element) -> Bool) {
      self._base = _base
      self._predicate = isIncluded
    }
  }
}

extension ExampleLazyFilterSequence.Iterator: IteratorProtocol, Sequence {
  public typealias Element = Base.Element
  
  /// Advances to the next element and returns it, or `nil` if no next element
  /// exists.
  ///
  /// Once `nil` has been returned, all subsequent calls return `nil`.
  ///
  /// - Precondition: `next()` has not been applied to a copy of `self`
  ///   since the copy was made.
  mutating func next() -> Element? {
    while let n = _base.next() {
      if _predicate(n) {
        return n
      }
    }
    return nil
  }
}



extension ExampleLazyFilterSequence: Sequence {
    typealias Element = Base.Element
    
    public func makeIterator() -> Iterator {
        return Iterator(_base: _base.makeIterator(), _predicate)
      }
}

extension ExampleLazyFilterSequence: LazySequenceProtocol {}


//extension LazySequenceProtocol {
//  public func filter(_ isIncluded: @escaping (Elements.Element) -> Bool) -> LazyFilterSequence<Self.Elements> {
//    return LazyFilterSequence(_base: self.elements, isIncluded)
//  }
//}



//struct ExampleMapFilterSequence: LazySequenceProtocol {
//    
//}
