//
//  Useful.swift
//

import Foundation

extension Sequence {
    public func toArray() -> Array<Element> {
        Array(self)
    }
}

extension Sequence where Element: Hashable {
    public func toSet() -> Set<Element> {
        Set(self)
    }
}

extension Collection where Index == Int {
    func adjustedOffset(_ offset: Int) -> Element {
        self[startIndex + offset]
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        self.reduce(.zero, +)
    }
}


extension Collection {
    func indices(where predicate: @escaping (Self.Element) throws -> Bool) rethrows -> [Self.Index] {
        try indices.filter { try predicate(self[$0]) }
    }
}

extension LazyCollection {
    func indices(where predicate: @escaping (Self.Element) -> Bool) -> LazyFilterCollection<Self.Indices> {
        indices.lazy.filter { predicate(self[$0]) }
    }
}
