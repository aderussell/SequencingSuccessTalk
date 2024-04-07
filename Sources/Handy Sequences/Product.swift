//
//  Product.swift
//

import Foundation

struct ARCombinationsSequence<Base: RandomAccessCollection>: Sequence where Base.Index == Int {
    internal let _base: Base
    
    struct Iterator: IteratorProtocol {
        typealias Element = (Base.Element, Base.Element)
        let _base: Base
        private var idxA: Int = 0
        private var idxB: Int = 1
        
        init(_base: Base) {
            self._base = _base
        }
        
        mutating func next() -> Element? {
            if idxB >= _base.count {
                if idxA >= _base.count - 2 {
                    return nil
                }
                idxA += 1
                idxB = idxA + 1
            }
            let values = (_base[idxA], _base[idxB])
            idxB += 1
            return values
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator(_base: _base)
    }
}

extension Array {
    func combinations() -> ARCombinationsSequence<Self> {
        ARCombinationsSequence(_base: self)
    }
}
