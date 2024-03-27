//
//  Grid+Print.swift
//

import Foundation

extension Grid where T == String {
    func print() {
        for y in 0..<height {
            var line = ""
            for x in 0..<width {
                line.append(self[.init(x: x, y: y)])
            }
            Swift.print(line)
        }
    }
}

extension Grid {
    func print(value: (Point<Int>) -> Character) {
        for y in 0..<height {
            var line = ""
            for x in 0..<width {
                line.append(value(.init(x: x, y: y)))
            }
            Swift.print(line)
        }
    }
}

extension Grid where T == Character {
    func print() {
        for y in 0..<height {
            let line = String(elements[y])
            Swift.print(line)
        }
    }
}
