//
//  LinearSampleableSequence.swift
//

import Foundation
import SwiftUI

public struct LinearSampleable<Base: Collection>: Sequence where Base.Element: SwiftUI.VectorArithmetic {
    public typealias Element = Base.Element
    let base: Base
    let innerSampleCount: Int
    
    public init(base: Base, innerSampleCount: Int) {
        self.base = base
        self.innerSampleCount = innerSampleCount
    }
    
    public struct Iterator: IteratorProtocol {
        var base: Base.Iterator
        var innerSampleCount: Int
        var currentSample: Element?
        var targetSample: Element?
        var step: Int = 0
        var isComplete = false
        var onFirstCall = true
        
        init(base: Base, innerSampleCount: Int) {
            var iterator = base.makeIterator()
            self.innerSampleCount = innerSampleCount + 1
            self.currentSample = iterator.next()
            self.targetSample = iterator.next()
            self.base = iterator
        }
        
        private func calculateNext(start: Element?, end: Element?, step: Int) -> Element? {
            guard let start else { return nil }
            guard let end else { return nil }
            let diff = end - start
            let stepDiff = diff.scaled(by: (1.0 / Double(innerSampleCount)))
            let result = start + stepDiff.scaled(by: Double(step + 1))
            return result
        }
        
        public mutating func next() -> Element? {
            guard !isComplete else { return nil }
            if onFirstCall, let currentSample {
                onFirstCall = false
                return currentSample
            }
            let next = calculateNext(start: currentSample, end: targetSample, step: step)
            guard let next else {
                isComplete = true
                return next
            }
            step += 1
            if step == innerSampleCount {
                step = 0
                currentSample = targetSample
                let next = base.next()
                if let next {
                    targetSample = next
                } else {
                    isComplete = true
                }
            }
            return next
        }
    }
    
    public func makeIterator() -> Iterator {
        Iterator(base: base, innerSampleCount: innerSampleCount)
    }
}
