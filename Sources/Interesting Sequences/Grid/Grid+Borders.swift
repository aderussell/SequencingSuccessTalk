//
//  Grid+Borders.swift
//

import Foundation
import Algorithms

public struct GridAdjacentBorderIterator<Element>: Collection {
    public typealias Index = Grid<Element>.Index
    
    fileprivate let grid: Grid<Element>
    fileprivate let origin: Point<Int>
    fileprivate let width: Int
    fileprivate let height: Int
    
    public let indices: Array<Point<Int>>
    
    public var count: Int { indices.count }
    
    
    init(grid: Grid<Element>, origin: Point<Int>, width: Int, height: Int, includeDiagonals: Bool, wrap: Bool) {
        self.grid = grid
        self.origin = origin
        self.width = width
        self.height = height
        let candidateCheck = wrap ? Self.wrapCandidate(offset:origin:width:height:) : Self.clipCandidate(offset:origin:width:height:)
        self.indices = Self.calculateBorder(grid: grid, origin: origin, width: width, height: height, includeDiagonals: includeDiagonals, candidateCheck: candidateCheck)
    }
    
    
    public var startIndex: Grid<Element>.Index { indices[0] }
    public var endIndex: Grid<Element>.Index { grid.endIndex }
    public subscript(position: Grid<Element>.Index) -> Element { grid[position] }
    
    public func index(after i: Grid<Element>.Index) -> Grid<Element>.Index {
        guard let idx = indices.firstIndex(of: i) else { fatalError("invalid index") }
        if i == indices.last { return endIndex }
        return indices[idx + 1]
    }
    
    
    static func wrapCandidate(offset: Point<Int>, origin: Point<Int>, width: Int, height: Int) -> Point<Int>? {
        return Point(x: (origin.x + offset.x + width) % width,
                     y: (origin.y + offset.y + height) % height)
    }
    
    static func clipCandidate(offset: Point<Int>, origin: Point<Int>, width: Int, height: Int) -> Point<Int>? {
        let candidateOffset = origin + offset
        guard (0..<width).contains(candidateOffset.x) && (0..<height).contains(candidateOffset.y) else { return nil }
        return candidateOffset
    }
    
    

    private static func calculateBorder(grid: Grid<Element>, 
                                        origin: Point<Int>,
                                        width: Int, height: Int,
                                        includeDiagonals: Bool,
                                        candidateCheck: (Point<Int>, Point<Int>, Int, Int) -> Point<Int>?) -> [Point<Int>] {
        guard width > 1 && height > 1 else { return [origin] }

        let topRange = includeDiagonals ? (0..<width-1) : (1..<width-1)
        let topOffsets = topRange.map { Point<Int>(x: $0, y: 0) }
        
        let rightRange = includeDiagonals ? 0..<height-1 : 1..<height-1
        let rightOffsets = rightRange.map { Point<Int>(x: width-1, y: $0) }
        
        let bottomRange = includeDiagonals ? stride(from: width-1, to: 0, by: -1) : stride(from: width-2, to: 0, by: -1)
        let bottomOffsets = bottomRange.map { Point<Int>(x: $0, y: height-1) }
        
        let leftRange = includeDiagonals ? stride(from: height-1, to: 0, by: -1) : stride(from: height-2, to: 0, by: -1)
        let leftOffsets = leftRange.map { Point<Int>(x: 0, y: $0) }
        
        
        let points = chain(chain(chain(topOffsets, rightOffsets), bottomOffsets), leftOffsets)
            .compactMap { candidateCheck($0, origin, grid.width, grid.height) }
        
        return points
    }
}



extension Grid {
    public func border() -> GridAdjacentBorderIterator<Element> {
        GridAdjacentBorderIterator(grid: self, origin: .zero, width: width, height: height, includeDiagonals: true, wrap: false)
    }
    
    
    public func border(from origin: Point<Int>, width: Int, height: Int, includeDiagonals: Bool = true) -> GridAdjacentBorderIterator<Element> {
        GridAdjacentBorderIterator(grid: self, origin: origin, width: width, height: height, includeDiagonals: includeDiagonals, wrap: false)
    }
    
    public func border(center: Point<Int>,
                       distanceX: Int = 1, distanceY: Int = 1, 
                       includeDiagonals: Bool = true,
                       wrapGrid: Bool = false) -> GridAdjacentBorderIterator<Element> {
        GridAdjacentBorderIterator(grid: self,
                                   origin: center - Point(x: distanceX, y: distanceY),
                                   width: 1 + distanceX + distanceX,
                                   height: 1 + distanceY + distanceY,
                                   includeDiagonals: includeDiagonals,
                                   wrap: wrapGrid)
    }
}
