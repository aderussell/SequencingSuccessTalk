//
//  Recursive.swift
//

import Foundation

struct RecursiveSequence<Base: Sequence, S1: Sequence>: Sequence where S1.Element == Base.Element {
    let base: Base
    let keyPath: KeyPath<Base.Element, S1>
    
    init(_ sequence: Base, keyPath: KeyPath<Base.Element, S1>) {
        self.base = sequence
        self.keyPath = keyPath
    }
    
    init<E>(element: E, keyPath: KeyPath<E, S1>) where Base == CollectionOfOne<E> {
        self.init(CollectionOfOne(element), keyPath: keyPath)
    }
    
    func makeIterator() -> RecursiveIterator {
        RecursiveIterator(base: base, keyPath: keyPath)
    }
    
    struct RecursiveIterator: IteratorProtocol {
        var stack: [Base.Element]
        var keyPath: KeyPath<Element, S1>
        
        init(base: Base, keyPath: KeyPath<Base.Element, S1>) {
            self.stack = Array(base.reversed())
            self.keyPath = keyPath
        }
        
        mutating func next() -> Base.Element? {
            guard let last = stack.popLast() else { return nil }
            let children = last[keyPath: keyPath]
            stack.append(contentsOf: children.reversed())
            return last
        }
    }
}

extension Sequence {
    func recursive<S1: Sequence>(keyPath: KeyPath<Element, S1>) -> RecursiveSequence<Self, S1> {
        RecursiveSequence(self, keyPath: keyPath)
    }
}
