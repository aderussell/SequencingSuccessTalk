//
//  Grid+SubSequence.swift
//

import Foundation

public struct GridSubSequence<Element>: Collection {
    public typealias Index = Grid<Element>.Index
    @usableFromInline
    let base: Grid<Element>
    @usableFromInline
    let origin: Point<Int>
    @usableFromInline
    let finalIndex: Point<Int>
    @usableFromInline
    internal let width: Int
    @usableFromInline
    internal let height: Int
    
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
    @inlinable
    public subscript(position: Index) -> Element { base[position] }
    
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

extension GridSubSequence: RandomAccessCollection {}

extension Grid {
    public func subgrid(origin: Index, width: Int, height: Int) -> GridSubSequence<Element> {
        assert(origin.x + width <= self.width, "Width too high")
        assert(origin.y + height <= self.height, "Height too high")
        return GridSubSequence(base: self, origin: origin, width: width, height: height)
    }
}


extension Grid {
    @inlinable
    public func column(_ column: Int) -> GridSubSequence<Element> {
        subgrid(origin: .init(x: column, y: 0), width: 1, height: height)
    }
    @inlinable
    public func row(_ row: Int) -> GridSubSequence<Element> {
        subgrid(origin: .init(x: 0, y: row), width: width, height: 1)
    }
}
