//
//  RecursiveCollection.swift
//

import Foundation

extension RecursiveSequence: Collection where Base: BidirectionalCollection, S1: BidirectionalCollection, S1.Index == Int, Base.Index == Int {
    public typealias Index = IndexPath
    
    public var startIndex: IndexPath { IndexPath(index: 0) }
    public var endIndex: IndexPath { IndexPath(index: base.count) }
    
    public subscript(position: IndexPath) -> Element {
        assert(!position.isEmpty, "Position indexPath cannot be empty")
        var indices = position.makeIterator()
        let initial = base[indices.next()!]
        return sequence(first: initial) {
            guard let index = indices.next() else { return nil }
            return $0[keyPath: keyPath][index]
        }
        .reduce(initial, { return $1 })
    }
    
    
    public func index(after i: IndexPath) -> IndexPath {
        assert(!i.isEmpty, "Position indexPath cannot be empty")
        let children = self[i][keyPath: keyPath]
        guard children.isEmpty else { return i.appending(0) }
        var currentPath = i
        while let currentIndex = currentPath.popLast(), !currentPath.isEmpty {
            let children = self[currentPath][keyPath: keyPath]
            if currentIndex < (children.count - 1) {
                return currentPath.appending(currentIndex + 1)
            }
        }
        return IndexPath(index: i[0] + 1)
    }
}

extension RecursiveSequence: BidirectionalCollection where Base: BidirectionalCollection, S1: BidirectionalCollection, S1.Index == Int, Base.Index == Int {
    public func index(before i: IndexPath) -> IndexPath {
        assert(!i.isEmpty, "Position indexPath cannot be empty")
        assert(i != startIndex, "Must be after start index")
        if i.last == 0 { return i.dropLast() }
        var currentPath = i.dropLast().appending(i.last! - 1)
        var parent = self[currentPath]
        while (!parent[keyPath: keyPath].isEmpty) {
            currentPath.append(parent[keyPath: keyPath].count - 1)
            parent = parent[keyPath: keyPath].last!
        }
        return currentPath
    }
}
