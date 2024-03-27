//
//  Recursive.swift
//

import Foundation

public struct RecursiveSequence<Base: Sequence, S1: Sequence>: Sequence where S1.Element == Base.Element {
    let base: Base
    let keyPath: KeyPath<Base.Element, S1>
    
    public init(_ sequence: Base, keyPath: KeyPath<Base.Element, S1>) {
        self.base = sequence
        self.keyPath = keyPath
    }
    
    public init<E>(element: E, keyPath: KeyPath<E, S1>) where Base == CollectionOfOne<E> {
        self.init(CollectionOfOne(element), keyPath: keyPath)
    }
    
    public func makeIterator() -> RecursiveIterator {
        RecursiveIterator(base: base, keyPath: keyPath)
    }
    
    public struct RecursiveIterator: IteratorProtocol {
        var stack: [Base.Element]
        var keyPath: KeyPath<Element, S1>
        
        init(base: Base, keyPath: KeyPath<Base.Element, S1>) {
            self.stack = Array(base.reversed())
            self.keyPath = keyPath
        }
        
        public mutating func next() -> Base.Element? {
            guard let last = stack.popLast() else { return nil }
            let children = last[keyPath: keyPath]
            stack.append(contentsOf: children.reversed())
            return last
        }
    }
    
    
}

public struct BreadthFirstRecursiveSequence<Base: Sequence, S1: Sequence>: Sequence where S1.Element == Base.Element {
    let base: Base
    let keyPath: KeyPath<Base.Element, S1>
    
    public init(_ sequence: Base, keyPath: KeyPath<Base.Element, S1>) {
        self.base = sequence
        self.keyPath = keyPath
    }
    
    public init<E>(element: E, keyPath: KeyPath<E, S1>) where Base == CollectionOfOne<E> {
        self.init(CollectionOfOne(element), keyPath: keyPath)
    }
    
    public func makeIterator() -> BreadthFirstRecursiveIterator {
        BreadthFirstRecursiveIterator(base: base, keyPath: keyPath)
    }
    
    public struct BreadthFirstRecursiveIterator: IteratorProtocol {
        var queue: [Base.Element]
        var keyPath: KeyPath<Element, S1>
        
        init(base: Base, keyPath: KeyPath<Base.Element, S1>) {
            self.queue = Array(base)
            self.keyPath = keyPath
        }
        
        public mutating func next() -> Base.Element? {
            guard !queue.isEmpty else { return nil }
            let next = queue.removeFirst()
            let children = next[keyPath: keyPath]
            queue.append(contentsOf: children)
            return next
        }
    }
}

extension Sequence {
    public func recursive<S1: Sequence>(keyPath: KeyPath<Element, S1>) -> RecursiveSequence<Self, S1> {
        RecursiveSequence(self, keyPath: keyPath)
    }
    
    public func recursive_bfs<S1: Sequence>(keyPath: KeyPath<Element, S1>) -> BreadthFirstRecursiveSequence<Self, S1> {
        BreadthFirstRecursiveSequence(self, keyPath: keyPath)
    }
}
