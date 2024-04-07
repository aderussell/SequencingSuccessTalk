//
//  Grid+Travel.swift
//

import Foundation

extension Grid {
    enum Direction: CaseIterable {
        case left
        case right
        case up
        case down
        
        @inlinable
        var pointDelta: Point<Int> {
            switch self {
            case .up:
                return .init(x: 0, y: -1)
            case .down:
                return .init(x: 0, y: 1)
            case .left:
                return .init(x: -1, y: 0)
            case .right:
                return .init(x: 1, y: 0)
            }
        }
    }
    
    private func nextPoint(from position: Point<Int>, direction: Direction, wrapping: Bool) -> Point<Int>? {
        let _maxX: Int = width - 1
        let _maxY: Int = height - 1
        
        var nextPoint = position + direction.pointDelta
        var wrapped = false
        switch direction {
        case .left:
            if nextPoint.x < 0 {
                nextPoint.x = _maxX
                wrapped = true
            }
        case .right:
            if nextPoint.x > _maxX {
                nextPoint.x = 0
                wrapped = true
            }
        case .up:
            if nextPoint.y < 0 {
                nextPoint.y = _maxY
                wrapped = true
            }
        case .down:
            if nextPoint.y > _maxY {
                nextPoint.y = 0
                wrapped = true
            }
        }
        guard wrapping || !wrapped else { return nil }
        return nextPoint
    }
    
    
    func walk(from point: Point<Int>, direction: Direction, allowWrapping: Bool, while closure: (Element) -> Bool) -> Point<Int>? {
        var next = nextPoint(from: point, direction: direction, wrapping: allowWrapping)
        while (next != nil) && closure(self[next!]) {
            next = nextPoint(from: next!, direction: direction, wrapping: allowWrapping)
        }
        return next
    }
    
    func travel(from point: Point<Int>, direction: Direction) -> [Element] {
        switch direction {
        case .right:
            guard point.x < width - 1 else { return [] }
            return Array(content(row: point.y).suffix(from: index(after: point)))
        case .down:
            let line = content(column: point.y)
            return Array(line.suffix(from: line.index(after: point)))
        case .left:
            guard point.x > 0 else { return [] }
            let line = content(row: point.y)
            return Array(line.prefix(upTo: point)).reversed()
        case .up:
            guard point.y > 0 else { return [] }
            let line = content(column: point.y)
            return Array(line.prefix(upTo: point)).reversed()
        }
    }
}
