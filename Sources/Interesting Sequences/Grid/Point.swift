//
//  Point.swift
//

import Foundation

public struct Point<T: Numeric> {
    public var x: T
    public var y: T
    
    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
}

extension Point: CustomStringConvertible {
    public var description: String { "[\(x), \(y)]" }
}

extension Point: Equatable where T: Hashable {}
extension Point: Hashable where T: Hashable {}


extension Point: Comparable where T: Hashable & Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.y == rhs.y { return lhs.x < rhs.x }
        return lhs.y < rhs.y
    }
}


extension Point: AdditiveArithmetic where T: Hashable {
    public static var zero: Point<T> {
        .init(x: 0, y: 0)
    }
    
    public static func + (lhs: Point<T>, rhs: Point<T>) -> Point<T> {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: Point<T>, rhs: Point<T>) -> Point<T> {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func +=(left: inout Point<T>, right: Point<T>) {
        left.x = left.x + right.x
        left.y = left.y + right.y
    }
}

extension Point where T == Int {
    func perpendicularNeighbours(width itemCount: Int, height rowCount: Int) -> [Point<T>] {
        let p = self
        let row = p.y
        let i = p.x
        var neighbours: [Point<T>] = []
        if i > 0 {
            neighbours.append(Point(x: i-1, y: row))
        }
        if i < itemCount-1 {
            neighbours.append(Point(x: i+1, y: row))
        }
        if row > 0 {
            neighbours.append(Point(x: i, y: row-1))
        }
        if row < rowCount-1 {
            neighbours.append(Point(x: i, y: row+1))
        }
        return neighbours
    }
    
    func perpendicularNeighbours() -> [Point<T>] {
        let p = self
        let row = p.y
        let i = p.x
        let neighbours: [Point<T>] = [
            Point(x: i-1, y: row),
            Point(x: i+1, y: row),
            Point(x: i, y: row-1),
            Point(x: i, y: row+1)
        ]
        return neighbours
    }
    
    func neighbours(width itemCount: Int, height rowCount: Int) -> [Point<T>] {
        let p = self
        let row = p.y
        let i = p.x
        var neighbours: [Point<T>] = []
        if i > 0 {
            neighbours.append(Point(x: i-1, y: row))
        }
        if i < itemCount-1 {
            neighbours.append(Point(x: i+1, y: row))
        }
        
        if row > 0 {
            if i > 0 {
                neighbours.append(Point(x: i-1, y: row-1))
            }
            neighbours.append(Point(x: i, y: row-1))
            if i < itemCount-1 {
                neighbours.append(Point(x: i+1, y: row-1))
            }
        }
        if row < rowCount-1 {
            if i > 0 {
                neighbours.append(Point(x: i-1, y: row+1))
            }
            neighbours.append(Point(x: i, y: row+1))
            if i < itemCount-1 {
                neighbours.append(Point(x: i+1, y: row+1))
            }
        }
        return neighbours
    }
    
    mutating func rotate(_ angle: Int) {
        let r = Float(angle) * .pi / 180.0
        let s = sin(r)
        let c = cos(r)
        let fX = Float(x)
        let fY = Float(y)
        x = Int((fX * c - fY * s).rounded())
        y = Int((fX * s + fY * c).rounded())
    }
}
