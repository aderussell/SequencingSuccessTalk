//
//  NthDimensionalArray.swift
//

import Foundation

struct NthDimensionalArray<T> {
    var content: [T]
    var dimensions: [Int]
    var offsets: [Int]
    init(_ dimensions: Int..., defaultValue: T) {
        var scale = 1
        var scales = [Int]()
        for (index, i) in dimensions.enumerated() {
            scale *= i
            if index != 0 {
                scales.append(i)
            }
        }
        var scaleProduct = 1
        self.offsets = [1]
        for i in scales.reversed() {
            scaleProduct *= i
            self.offsets.append(scaleProduct)
        }
        self.offsets.reverse()
        self.content = .init(repeating: defaultValue, count: scale)
        self.dimensions = dimensions
    }
    
    subscript(_ positions: Int...) -> T {
        get {
            let finalIndex = zip(positions, offsets).reduce(0, { $0 + ($1.0 * $1.1)})
            return content[finalIndex]
        }
        set {
            let finalIndex = zip(positions, offsets).reduce(0, { $0 + ($1.0 * $1.1)})
            content[finalIndex] = newValue
        }
    }
    
    subscript(_ positions: [Int]) -> T {
        get {
            let finalIndex = zip(positions, offsets).reduce(0, { $0 + ($1.0 * $1.1)})
            return content[finalIndex]
        }
        set {
            let finalIndex = zip(positions, offsets).reduce(0, { $0 + ($1.0 * $1.1)})
            content[finalIndex] = newValue
        }
    }
}

extension NthDimensionalArea {
    func shift(axis: Int, by: Int) -> Self {
        var copy = self
        copy.mins[axis] += by
        copy.maxs[axis] += by
        return copy
    }
}

struct NthDimensionalArea: Sequence {
    var mins: [Int]
    var maxs: [Int]
    var dimensions: Int { mins.count }
    
    struct Iterator: IteratorProtocol {
        let mins: [Int]
        let maxs: [Int]
        var current: [Int]
        var finished: Bool = false
        
        typealias Element = [Int]
        
        mutating func next() -> Element? {
            if finished { return nil }
            let result = current
            var newCurrent = current
            newCurrent[newCurrent.count-1] += 1
            for index in newCurrent.indices.reversed() {
                if newCurrent[index] > maxs[index] {
                    newCurrent[index] = mins[index]
                    if index > 0 {
                        newCurrent[index - 1] += 1
                    } else if index == 0 {
                        finished = true
                    }
                }
            }
            current = newCurrent
            return result
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator(mins: mins, maxs: maxs, current: mins)
    }
    
    func intersects(_ other: NthDimensionalArea) -> Bool {
        for d in 0..<self.dimensions {
            let range = self.mins[d]...self.maxs[d]
            let otherRange = other.mins[d]...other.maxs[d]
            if !range.overlaps(otherRange) { return false }
        }
        return true
    }
}
