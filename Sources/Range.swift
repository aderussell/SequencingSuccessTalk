//
//  Range.swift
//

import Foundation

struct ExampleRange<Bound> {
    let lower: Bound
    let upper: Bound
}

struct ExampleRangeIterator<Bound: SignedInteger>: IteratorProtocol {
    typealias Element = Bound
    var lower, upper, current: Bound
    
    init(lower: Bound, upper: Bound) {
        self.lower = lower
        self.upper = upper
        self.current = lower
    }
    
    mutating func next() -> Element? {
        guard current < upper else { return nil }
        defer { current += 1 }
        return current
    }
}

extension ExampleRange: Sequence where Bound: Strideable & SignedInteger {
    func makeIterator() -> some IteratorProtocol {
        ExampleRangeIterator(lower: lower, upper: upper)
    }
    
    var underestimatedCount: Int { Int(upper-lower) + 1 }
}
