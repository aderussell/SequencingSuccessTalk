//
//  Grid.swift
//

import Foundation

public struct Grid<Element> {
    @usableFromInline
    var elements: [Element]
    @usableFromInline
    var width: Int
    @usableFromInline
    var height: Int
    
    public init(elements: [[Element]]) {
        self.elements = elements.flatMap { $0 }
        self.width = elements.first!.count
        self.height = elements.count
    }
    
    public init<S: Sequence<Element>>(_ elements: S, width: Int, height: Int) {
        let allElements = Array(elements)
        assert(allElements.count == width * height, "Invalid element count for width/height")
        self.elements = allElements
        self.width = width
        self.height = height
    }
    
    public init(width: Int, height: Int, initial: Element) {
        self.elements = Array(repeating: initial, count: width * height)
        self.width = width
        self.height = height
    }
    
    @inlinable
    internal func linearIndex(for index: Index) -> Int {
        index.x + index.y * width
    }
    
    @inlinable
    internal func index(from linearIndex: Int) -> Index {
        let y = linearIndex / width
        let x = linearIndex % width
        return .init(x: x, y: y)
    }
}

extension Grid: Equatable where Element: Equatable {}
extension Grid: Hashable where Element: Hashable {}


extension Grid: Collection {
    public typealias Iterator = IndexingIterator<Self>
    public typealias Index = Point<Int>
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>
    
    public var count: Int { width * height }
    public var isEmpty: Bool { elements.isEmpty }
    
    @inlinable
    public var startIndex: Index { .zero }
    @inlinable
    public var endIndex: Index { index(from: count) }
    
    @inlinable
    public subscript(point: Point<Int>) -> Element {
        get { elements[linearIndex(for: point)] }
        set { elements[linearIndex(for: point)] = newValue }
    }
    
    public func index(after i: Index) -> Index {
        let linear = linearIndex(for: i)
        assert(linear < count, "Index out of bounds")
        return index(from: linear + 1)
    }
    
}

extension Grid: BidirectionalCollection {    
    public func index(before i: Index) -> Index {
        assert(i > .zero, "Index out of bounds")
        let linear = linearIndex(for: i)
        return index(from: linear - 1)
    }
}

extension Grid: RandomAccessCollection { }
