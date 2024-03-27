//
//  File.swift
//  
//
//  Created by Adrian Russell on 26/03/2024.
//

import Foundation

public struct AsyncThrowingUnfoldSequence<Element, State>: AsyncSequence, AsyncIteratorProtocol {
    public typealias AsyncIterator = Self
    public typealias Element = Element
    
    @usableFromInline
    internal var _state: State
    @usableFromInline
    internal let _next: (inout State) async throws -> Element?
    @usableFromInline
    internal var _done = false
    
    @inlinable
    public mutating func next() async throws -> Element? {
       guard !_done else { return nil }
        if let elt = try await _next(&_state) {
            return elt
        } else {
            _done = true
            return nil
        }
    }
    
    @inlinable
    public func makeAsyncIterator() -> Self {
        self
    }
    
    @inlinable
    internal init(_state: State, _next: @escaping (inout State) async throws -> Element?) {
        self._state = _state
        self._next = _next
    }
}

public struct AsyncUnfoldSequence<Element, State>: AsyncSequence, AsyncIteratorProtocol {
    public typealias AsyncIterator = Self
    public typealias Element = Element
    
    @usableFromInline
    internal var _state: State
    @usableFromInline
    internal let _next: (inout State) async -> Element?
    @usableFromInline
    internal var _done = false
    
    @inlinable
    public mutating func next() async -> Element? {
       guard !_done else { return nil }
        if let elt = await _next(&_state) {
            return elt
        } else {
            _done = true
            return nil
        }
    }
    
    @inlinable
    public func makeAsyncIterator() -> Self {
        self
    }
    
    @inlinable
    internal init(_state: State, _next: @escaping (inout State) async -> Element?) {
        self._state = _state
        self._next = _next
    }
}


public typealias AsyncUnfoldFirstSequence<T> = AsyncUnfoldSequence<T, (T?, Bool)>
public typealias AsyncThrowingUnfoldFirstSequence<T> = AsyncThrowingUnfoldSequence<T, (T?, Bool)>


@inlinable
public func asyncSequence<T, State>(state: State, next: @escaping (inout State) async throws -> T?)
  -> AsyncThrowingUnfoldSequence<T, State> {
      return AsyncThrowingUnfoldSequence(_state: state, _next: next)
}

@inlinable
public func asyncSequence<T, State>(state: State, next: @escaping (inout State) async -> T?)
  -> AsyncUnfoldSequence<T, State> {
      return AsyncUnfoldSequence(_state: state, _next: next)
}

@inlinable
public func asyncSequence<T>(first: T, next: @escaping (T) async -> T?) -> AsyncUnfoldFirstSequence<T> {
    // The trivial implementation where the state is the next value to return
    // has the downside of being unnecessarily eager (it evaluates `next` one
    // step in advance). We solve this by using a boolean value to disambiguate
    // between the first value (that's computed in advance) and the rest.
    return asyncSequence(state: (first, true), next: { (state: inout (T?, Bool)) -> T? in
        switch state {
        case (let value, true):
            state.1 = false
            return value
        case (let value?, _):
            let nextValue = await next(value)
            state.0 = nextValue
            return nextValue
        case (nil, _):
            return nil
        }
    })
}


@inlinable
public func asyncSequence<T>(first: T, next: @escaping (T) async throws -> T?) -> AsyncThrowingUnfoldFirstSequence<T> {
    // The trivial implementation where the state is the next value to return
    // has the downside of being unnecessarily eager (it evaluates `next` one
    // step in advance). We solve this by using a boolean value to disambiguate
    // between the first value (that's computed in advance) and the rest.
    return asyncSequence(state: (first, true), next: { (state: inout (T?, Bool)) throws -> T? in
        switch state {
        case (let value, true):
            state.1 = false
            return value
        case (let value?, _):
            let nextValue = try await next(value)
            state.0 = nextValue
            return nextValue
        case (nil, _):
            return nil
        }
    })
}
