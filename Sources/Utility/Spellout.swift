//
//  Spellout.swift
//

import Foundation

protocol NSNumberConvertible {
    /// Create an NSNumber out of this concrete numeric type
    var nsNumber: NSNumber { get }
}

extension Decimal: NSNumberConvertible {
    var nsNumber: NSNumber { self as NSNumber }
}
extension Double: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Float: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Int8: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Int32: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Int: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Int64: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension Int16: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}


// all the unsigned type we support
extension UInt8: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension UInt32: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension UInt: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension UInt64: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}
extension UInt16: NSNumberConvertible {
    var nsNumber: NSNumber { NSNumber(value: self) }
}

// Prefab one, is there better way. Can't put this in SpelloutNumberFormatStyle with static computed property
let spelloutNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter
}()

struct SpelloutNumberFormatStyle<Value: NSNumberConvertible>: FormatStyle {
    func format(_ value: Value) -> String {
        spelloutNumberFormatter.string(from: value.nsNumber)!
    }
}

extension FormatStyle where Self == SpelloutNumberFormatStyle<Decimal> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Double> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Float> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Int8> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Int32> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Int> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Int64> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<Int16> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<UInt8> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<UInt> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<UInt64> {
    static var spellOut: Self { .init() }
}
extension FormatStyle where Self == SpelloutNumberFormatStyle<UInt16> {
    static var spellOut: Self { .init() }
}
