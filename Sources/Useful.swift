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
