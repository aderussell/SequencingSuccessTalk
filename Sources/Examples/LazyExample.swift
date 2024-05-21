//
//  LazyExample.swift
//

import Foundation

func runLazyExample() {
    let value = (0..<1_000_000)
        .filter { $0.isMultiple(of: 2) }
        .map { $0.formatted(.spellOut) }
        .filter { $0.contains("v") }
        .prefix(100)
    
    print(value.first!)
    print(value.last!)
    
    
    let lazyValue = (0..<1_000_000)
        .lazy
        .filter { $0.isMultiple(of: 2) }
        .map { $0.formatted(.spellOut) }
        .filter { $0.contains("v") }
        .prefix(100)
    
    print(lazyValue.first!)
    print(lazyValue.last!)
    
    
    let wrappedLazyValue = (0..<1_000_000)
        .lazy
        .filter { $0.isMultiple(of: 2) }
        .map { $0.formatted(.spellOut) }
        .filter { $0.contains("v") }
        .prefix(100)
        .toArray()
    
    print(wrappedLazyValue.first!)
    print(wrappedLazyValue.last!)
}
