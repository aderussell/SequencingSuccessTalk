//
//  Grid+Rotation.swift
//

import Foundation

public struct GridOrientatedSequence<T>: Sequence {
    let base: Grid<T>
    let includeFlipped: Bool

    public struct Iterator: IteratorProtocol {
        public typealias Element = Grid<T>
        var grid: Grid<T>
        var count = 0
        var includeFlipped: Bool

        public mutating func next() -> Element? {
            defer { count += 1 }
            guard count > 0 else { return grid }
            guard count < 4 || includeFlipped else { return nil }
            guard count < 8 else { return nil }

            if count == 4 {
                grid.flip()
            }

            grid.rotateRight()
            return grid
        }
    }

    public func makeIterator() -> Iterator {
        return Iterator(grid: base, includeFlipped: includeFlipped)
    }
}

extension Grid {
    func rotatedRight() -> Grid {
        let columns = (0..<width).map { content(column: $0).reversed() }
        return .init(elements: columns)
    }

    func flippedVertically() -> Grid {
        let columns = (0..<width).map { content(column: $0) }
        return .init(elements: columns.reversed())
    }
}

extension Grid {
    mutating func rotateRight() {
        let columns = (0..<width).map { content(column: $0).reversed() }
        elements = ContiguousArray(columns.lazy.flatMap { $0 })
        swap(&width, &height)
    }

    mutating func flip() {
        let columns = (0..<width).map { content(column: $0) }
        elements = ContiguousArray(columns.lazy.reversed().flatMap { $0 })
    }
}



extension Grid {
    public func rotations(includeFlipped: Bool) -> GridOrientatedSequence<Element> {
        GridOrientatedSequence(base: self, includeFlipped: includeFlipped)
    }
}


extension Grid {
    func transposed() -> Self {
        let columns = (0..<width).map { content(column: $0) }
        return .init(elements: columns)
    }
}
