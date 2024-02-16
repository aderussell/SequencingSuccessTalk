//
//  File.swift
//  
//
//  Created by Adrian Russell on 15/02/2024.
//

import Foundation


extension Sequence {
    
    func exampleMap<T>(_ transform: (Self.Element) -> T) -> [T] {
        var results = Array<T>()
        results.reserveCapacity(underestimatedCount)
        var iterator = makeIterator()
        while let val = iterator.next() {
            results.append(transform(val))
        }
        return results
    }
}
