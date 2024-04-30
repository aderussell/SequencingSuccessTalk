// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


let range = ExampleRange(lower: 0, upper: 10)
for i in range {
    print(i)
}

let f = [1,2,3,4]
let f1 = f.filter({ $0.isMultiple(of: 2) })
let f2 = f1.map({ String($0) })

let l = [1,2,3,4].lazy
let l1 = l.filter({ $0.isMultiple(of: 2) })
let l2 = l1.map({ String($0) })

print(l2)


runThemeParkExample()
runFileSystemExample()
runMessagesExample()
runSpirographExample()
