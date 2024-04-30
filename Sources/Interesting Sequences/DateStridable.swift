//
//  DateStridable.swift
//

import Foundation

extension DateComponents {
    public static func seconds(_ value: Int) -> Self { .init(second: value) }
    public static func minutes(_ value: Int) -> Self { .init(minute: value) }
    public static func hours(_ value: Int) -> Self { .init(hour: value) }
    public static func days(_ value: Int) -> Self { .init(day: value) }
    public static func weeks(_ value: Int) -> Self { .init(weekOfYear: value) }
    public static func months(_ value: Int) -> Self { .init(month: value) }
    public static func years(_ value: Int) -> Self { .init(year: value) }
}

public struct DateStrideSequence: Sequence {
    public typealias Element = Date
    
    var _start: Date
    var _end: Date
    var stride: DateComponents
    var calendar: Calendar
    
    public struct Iterator: IteratorProtocol {
        var _start: Date
        var _end: Date
        var stride: DateComponents
        var calendar: Calendar
        let ascending: Bool
        
        public mutating func next() -> Date? {
            if ascending {
                guard _start < _end else { return nil }
            } else {
                guard _start > _end else { return nil }
            }
            defer { _start = calendar.date(byAdding: stride, to: _start)! }
            return _start
        }
        
    }
    
    public func makeIterator() -> Iterator {
        Iterator(_start: _start, _end: _end, stride: stride, calendar: calendar, ascending: isAscending())
    }
    
    private func isAscending() -> Bool {
        _start < calendar.date(byAdding: stride, to: _start)!
    }
}

public struct DateStrideThroughSequence: Sequence {
    public typealias Element = Date
    
    var _start: Date
    var _end: Date
    var stride: DateComponents
    var calendar: Calendar
    
    public struct Iterator: IteratorProtocol {
        var _start: Date
        var _end: Date
        var stride: DateComponents
        var calendar: Calendar
        let ascending: Bool
        
        public mutating func next() -> Date? {
            if ascending {
                guard _start <= _end else { return nil }
            } else {
                guard _start >= _end else { return nil }
            }
            defer { _start = calendar.date(byAdding: stride, to: _start)! }
            return _start
        }
    }
    
    public func makeIterator() -> Iterator {
        Iterator(_start: _start, _end: _end, stride: stride, calendar: calendar, ascending: isAscending())
    }
    
    private func isAscending() -> Bool {
        _start < calendar.date(byAdding: stride, to: _start)!
    }
}

public func strideDate(from: Date, to: Date, by: DateComponents, calendar: Calendar = .current) -> DateStrideSequence {
    DateStrideSequence(_start: from, _end: to, stride: by, calendar: calendar)
}

public func strideDate(from: Date, through: Date, by: DateComponents, calendar: Calendar = .current) -> DateStrideThroughSequence {
    DateStrideThroughSequence(_start: from, _end: through, stride: by, calendar: calendar)
}


public func strideDate(for interval: DateInterval, by: DateComponents, calendar: Calendar = .current) -> DateStrideSequence {
    DateStrideSequence(_start: interval.start, _end: interval.end, stride: by, calendar: calendar)
}

public func strideDate(through interval: DateInterval, by: DateComponents, calendar: Calendar = .current) -> DateStrideThroughSequence {
    DateStrideThroughSequence(_start: interval.start, _end: interval.end, stride: by, calendar: calendar)
}



extension DateInterval {
    func stride(by: DateComponents, calendar: Calendar = .current) -> DateStrideThroughSequence {
        DateStrideThroughSequence(_start: start, _end: end, stride: by, calendar: calendar)
    }
}
