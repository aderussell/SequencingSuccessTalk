//
//  Recursive+Useful.swift
//

import Foundation


extension RecursiveSequence where Self: Collection {
    
    /// Returns an array which contains all the elements encountered along the specified index path.
    /// - Parameter path: The indexPath to get the elements along
    /// - Returns: An array which contains all the elements within the recursive sequence along the specified index path.
    func elements(along path: IndexPath) -> [Element] {
        return sequence(state: path) { state in
            defer { state = state.dropLast() }
            return self[state]
        }.reversed()
    }
}
