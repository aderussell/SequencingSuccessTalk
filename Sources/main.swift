// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, world!")

struct ExampleSequence: Sequence {
    typealias Element = Character
    
    struct Iterator: IteratorProtocol {
        var called = false
        mutating func next() -> Character? {
            guard !called else { return nil }
            defer { called = true }
            return "A"
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator()
    }
}

struct ExampleCollection: Collection {
    typealias Element = Character
    typealias Index = Int
    
    var startIndex: Int = 0
    
    var endIndex: Int = 1
    
    
    subscript(position: Int) -> Character {
        "A"
    }
    
    func index(after i: Int) -> Int {
        0
    }
}


struct ExampleBiDrectionCollection: BidirectionalCollection {
    
    typealias Element = Character
    typealias Index = Int
    
    func index(before i: Int) -> Int {
        0
    }
    
    func index(after i: Int) -> Int {
        1
    }
    
    subscript(position: Int) -> Character {
        "A"
//        _read {
//            <#code#>
//        }
    }
    
    var startIndex: Int = 0
    
    var endIndex: Int = 1
}


struct ExampleRandomAccessCollection: RandomAccessCollection {
    var startIndex: Int = 0
    var endIndex: Int = 1
    
    typealias Element = Character
    typealias Index = Int
    
    subscript(position: Int) -> Character {
        "A"
    }
}




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


struct CounterToTen: IteratorProtocol {
    typealias Element = Int
    var val = 0
    mutating func next() -> Self.Element? {
        guard val < 10 else { return nil }
        val += 1
        return val
    }
}
var counter = CounterToTen()
while let count = counter.next() {
    print(count)
}


//for i in CounterToTen() {
//    print(i)
//}


let i = stride(from: 0, to: 10, by: 1)
print(i)




for i in Fibonacci().prefix(20) {
    print(i)
}

struct RecursiveType {
    var name: String
    var children: [RecursiveType]
}


let r = RecursiveType(name: "0", children: [
    RecursiveType(name: "0.0", children: [
        RecursiveType(name: "0.0.0", children: []),
        RecursiveType(name: "0.0.1", children: [
            RecursiveType(name: "0.0.1.0", children: []),
            RecursiveType(name: "0.0.1.1", children: []),
        ]),
        RecursiveType(name: "0.0.2", children: [])
    ]),
    RecursiveType(name: "0.1", children: [
        RecursiveType(name: "0.1.0", children: []),
        RecursiveType(name: "0.1.1", children: [
            RecursiveType(name: "0.1.1.0", children: []),
            RecursiveType(name: "0.1.1.1", children: []),
        ]),
        RecursiveType(name: "0.1.2", children: [])
    ])
])
let r1 = RecursiveType(name: "1", children: [
    RecursiveType(name: "1.0", children: [
        RecursiveType(name: "1.0.0", children: []),
        RecursiveType(name: "1.0.1", children: [
            RecursiveType(name: "1.0.1.0", children: []),
            RecursiveType(name: "1.0.1.1", children: []),
        ]),
        RecursiveType(name: "1.0.2", children: [])
    ]),
    RecursiveType(name: "1.1", children: [
        RecursiveType(name: "1.1.0", children: []),
        RecursiveType(name: "1.1.1", children: [
            RecursiveType(name: "1.1.1.0", children: []),
            RecursiveType(name: "1.1.1.1", children: []),
        ]),
        RecursiveType(name: "1.1.2", children: [])
    ])
])


let s1 = RecursiveSequence(element: r, keyPath: \.children)
for thing in s1 {
    print(thing.name)
}
print("----------")
let s2 = RecursiveSequence([r, r1], keyPath: \.children)
for thing in s2 {
    print(thing.name)
}
print("----------")
for thing in [r, r1].recursive(keyPath: \.children) {
    print(thing.name)
}
