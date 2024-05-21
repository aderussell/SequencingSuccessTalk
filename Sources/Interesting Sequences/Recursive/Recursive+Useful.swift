//
//  Recursive+Useful.swift
//

import Foundation


extension RecursiveSequence where Self: Collection {
    
    /// Returns an array which contains all the elements encountered along the specified index path.
    /// - Parameter path: The indexPath to get the elements along
    /// - Returns: An array which contains all the elements within the recursive sequence along the specified index path.
    public func elements(along path: IndexPath) -> [Element] {
        guard !path.isEmpty else { return [] }
        var indices = path.makeIterator()
        let initial = base[indices.next()!]
        return sequence(first: initial) {
            guard let index = indices.next() else { return nil }
            return $0[keyPath: keyPath][index]
        }.toArray()
    }
}
