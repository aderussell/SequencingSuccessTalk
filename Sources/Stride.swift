//
//  Stride.swift
//

import Foundation


struct ExampleStrideTo<Bound: Strideable> {
    let lower: Bound
    let upper: Bound
    let stride: Bound.Stride
}

struct ExampleStrideToIterator<Bound: Strideable> {
    internal let _start: Element
    internal let _end: Element
    internal let _stride: Element.Stride
    internal var _current: (index: Int?, value: Element)

    internal init(_ start: Element, end: Element, stride: Element.Stride) {
        _start = start
        _end = end
        _stride = stride
        _current = (0, _start)
    }
}

extension ExampleStrideToIterator: IteratorProtocol {
    mutating func next() -> Bound? {
        let result = _current.value
        if _stride > 0 ? result >= _end : result <= _end { return nil }
        _current = Element._step(after: _current, from: _start, by: _stride)
        return result
    }
}

extension ExampleStrideTo: Sequence {
    func makeIterator() -> some IteratorProtocol {
        ExampleStrideToIterator(lower, end: upper, stride: stride)
    }
}


// MARK: - Stride Through

struct ExampleStrideThrough<Bound> {
    let lower: Bound
    let upper: Bound
    let stride: Bound
}
