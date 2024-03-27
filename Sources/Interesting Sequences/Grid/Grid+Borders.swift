//
//  Grid+Borders.swift
//

import Foundation

public struct GridAdjacentBorderIterator<Element>: Collection {
    
    fileprivate let grid: Grid<Element>
    fileprivate let origin: Point<Int>
    fileprivate let width: Int
    fileprivate let height: Int
    
    public typealias Index = Grid<Element>.Index
    public let indices: Array<Point<Int>>
    
    
    
    init(grid: Grid<Element>, origin: Point<Int>, width: Int, height: Int, includeDiagonals: Bool) {
        self.grid = grid
        self.origin = origin
        self.width = width
        self.height = height
        self.indices = Self.calculateBorder(grid: grid, origin: origin, width: width, height: height, includeDiagonals: includeDiagonals)
    }
    
    
    public var startIndex: Grid<Element>.Index { indices[0] }
    public var endIndex: Grid<Element>.Index { grid.index(after: indices.last!) }
    public subscript(position: Grid<Element>.Index) -> Element { grid[position] }
    
    public func index(after i: Grid<Element>.Index) -> Grid<Element>.Index {
        guard let idx = indices.firstIndex(of: i) else { fatalError("invalid index") }
        if i == indices.last { return endIndex }
        return indices[idx + 1]
    }
    

    private static func calculateBorder(grid: Grid<Element>, origin: Point<Int>, width: Int, height: Int, includeDiagonals: Bool) -> [Point<Int>] {
        var points = [Point<Int>]()

        let minX = (origin.x - 1)
        let maxX = (origin.x + width)
        let minY = (origin.y - 1)
        let maxY = (origin.y + height)

        // top ->
        if minY >= 0, includeDiagonals {
            if minX >= 0 {
                points.append(.init(x: minX, y: minY))
            }

            let end = Swift.min(origin.x + width, grid.width)
            for x in origin.x..<end {
                points.append(.init(x: x, y: minY))
            }

            if includeDiagonals, maxX < grid.width {
                points.append(.init(x: maxX, y: minY))
            }
        }

        // right v
        if maxX < grid.width {
            let end = Swift.min(origin.y + height, grid.height)
            for y in (origin.y)..<(end) {
                points.append(.init(x: maxX, y: y))
            }
        }


        // bottom
        if maxY < grid.height {
            if minX >= 0 {
                points.append(.init(x: minX, y: maxY))
            }

            let end = Swift.min(origin.x + width, grid.width)
            for x in origin.x..<end {
                points.append(.init(x: x, y: maxY))
            }

            if includeDiagonals, maxX < grid.width {
                points.append(.init(x: maxX, y: maxY))
            }
        }

        // left
        if minX >= 0 {
            let end = Swift.min(origin.y + height, grid.height)
            for y in (origin.y)..<(end) {
                points.append(.init(x: minX, y: y))
            }
        }

        return points
    }
}

extension Grid {
    func border(from origin: Point<Int>, width: Int, height: Int, includeDiagonals: Bool = true) -> GridAdjacentBorderIterator<T> {
        GridAdjacentBorderIterator(grid: self, origin: origin, width: width, height: height, includeDiagonals: includeDiagonals)
    }
}
