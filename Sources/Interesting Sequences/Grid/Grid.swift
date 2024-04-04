//
//  Grid.swift
//

import Foundation

public struct Grid<T> {
    @usableFromInline
    var elements: [T]
    @usableFromInline
    var width: Int
    @usableFromInline
    var height: Int
    
    public init(elements: [[T]]) {
        self.elements = elements.flatMap { $0 }
        self.width = elements.first!.count
        self.height = elements.count
    }
    
    public init(width: Int, height: Int, initial: T) {
        self.elements = Array(repeating: initial, count: width * height)
        self.width = width
        self.height = height
    }
    
    @inlinable
    func linearIndex(for index: Index) -> Int {
        index.x + index.y * width
    }
    
    @inlinable
    func index(from linearIndex: Int) -> Index {
        let y = linearIndex / width
        let x = linearIndex % width
        return .init(x: x, y: y)
    }
}

extension Grid: Equatable where T: Equatable {}
extension Grid: Hashable where T: Hashable {}


extension Grid: Collection {
    public typealias Element = T
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
    public subscript(point: Point<Int>) -> T {
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


public struct GridSubSequence<Element>: Collection {
    @usableFromInline
    let base: Grid<Element>
    @usableFromInline
    let origin: Point<Int>
    @usableFromInline
    let finalIndex: Point<Int>
    
    private let width: Int
    private let height: Int
    
    init(base: Grid<Element>, origin: Point<Int>, width: Int, height: Int) {
        self.base = base
        self.origin = origin
        self.finalIndex = origin + Point(x: width-1, y: height-1)
        self.width = width
        self.height = height
    }
    @inlinable
    public var startIndex: Point<Int> { origin }
    @inlinable
    public var endIndex: Point<Int> { base.index(after: finalIndex) }
    
    public subscript(position: Point<Int>) -> Element { base[position] }
    
    public func index(after: Point<Int>) -> Point<Int> {
        assert(after < endIndex, "Index out of bounds")
        guard after < finalIndex else { return endIndex }
        let x = after.x
        let y = after.y
        let maxX = startIndex.x + (width - 1)
        if x == maxX { return Point(x: startIndex.x, y: y+1) }
        return Point(x: x+1, y: y)
    }
}

extension GridSubSequence: BidirectionalCollection {
    public func index(before i: Point<Int>) -> Point<Int> {
        assert(i > startIndex, "Index out of bounds")
        if i == endIndex { return finalIndex }
        let x = i.x
        let y = i.y
        if x == startIndex.x { return Point(x: x, y: y-1) }
        return Point(x: x-1, y: y)
    }
}


extension Grid {
    public func subgrid(origin: Index, width: Int, height: Int) -> GridSubSequence<Element> {
        assert(origin.x + width <= self.width, "Width too high")
        assert(origin.y + height <= self.height, "Height too high")
        return GridSubSequence(base: self, origin: origin, width: width, height: height)
    }
}


extension Grid {
    public func content(column: Int) -> GridSubSequence<Element> {
        subgrid(origin: .init(x: column, y: 0), width: 1, height: height)
    }
    
    public func content(row: Int) -> GridSubSequence<Element> {
        subgrid(origin: .init(x: 0, y: row), width: width, height: 1)
    }
//    
//    mutating func insert(columnValue: T, at index: Int) {
//        for rowIndex in 0..<height {
//            elements[rowIndex].insert(columnValue, at: index)
//        }
//    }
//    
//    mutating func insert(rowValue: T, at index: Int) {
//        let row = Array(repeating: rowValue, count: width)
//        elements.insert(row, at: index)
//    }
}


//

//
//
    
//

//}
//
extension Grid {
    func transposed() -> Self {
        let columns = (0..<width).map { Array(content(column: $0)) }
        return .init(elements: columns)
    }
}
//
//
