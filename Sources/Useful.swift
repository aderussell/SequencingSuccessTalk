//
//  Useful.swift
//

import Foundation

extension Sequence {
    func toArray() -> Array<Element> {
        Array(self)
    }
}

extension Sequence where Element: Hashable {
    func toSet() -> Set<Element> {
        Set(self)
    }
}
