//
//  Events.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 22.05.21.
//

import RxSwift
import RxTest
import XCTest

public struct SingleTimeEvent<T>: Equatable  where T: Equatable {
    let time: TestTime
    let event: SingleEvent<T>
    
    public init(time: TestTime, event: SingleEvent<T>) {
        self.time = time
        self.event = event
    }
}

public struct CompletableTimeEvent: Equatable {
    let time: TestTime
    let event: CompletableEvent
    
    public init(time: TestTime, event: CompletableEvent) {
        self.time = time
        self.event = event
    }
}

extension SingleTimeEvent: CustomDebugStringConvertible {
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String {
        return "\(self.event) @ \(self.time)"
    }
}

extension CompletableTimeEvent: CustomDebugStringConvertible {
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String {
        return "\(self.event) @ \(self.time)"
    }
}


/// A way to use built in XCTest methods with objects that are partially equatable.
///
/// If this can be done simpler, PRs are welcome :)
public struct AnyEquatable<Target>
    : Equatable {
    public typealias Comparer = (Target, Target) -> Bool

    let _target: Target
    let _comparer: Comparer

    public init(target: Target, comparer: @escaping Comparer) {
        self._target = target
        self._comparer = comparer
    }
}

public func == <T>(lhs: AnyEquatable<T>, rhs: AnyEquatable<T>) -> Bool {
    return lhs._comparer(lhs._target, rhs._target)
}

extension AnyEquatable
    : CustomDebugStringConvertible
    , CustomStringConvertible  {
    public var description: String {
        return "\(self._target)"
    }

    public var debugDescription: String {
        return "\(self._target)"
    }
}

/**
 Asserts two lists of events are equal.

 Event is considered equal if:
 * `Next` events are equal if they have equal corresponding elements.
 * `Error` events are equal if errors have same domain and code for `NSError` representation and have equal descriptions.
 * `Completed` events are always equal.

 - parameter lhs: first set of events.
 - parameter lhs: second set of events.
 */
public func XCTAssertEqual<Element: Equatable>(_ lhs: [SingleTimeEvent<Element>], _ rhs: [SingleTimeEvent<Element>], file: StaticString = #file, line: UInt = #line) {
    let leftEquatable = lhs.map { AnyEquatable(target: $0, comparer: ==) }
    let rightEquatable = rhs.map { AnyEquatable(target: $0, comparer: ==) }
    #if os(Linux)
        XCTAssertEqual(leftEquatable, rightEquatable)
    #else
        XCTAssertEqual(leftEquatable, rightEquatable, file: file, line: line)
    #endif
    if leftEquatable == rightEquatable {
        return
    }

    printSequenceDifferences(lhs, rhs, ==)
}

/**
 Asserts two lists of events are equal.

 Event is considered equal if:
 * `Next` events are equal if they have equal corresponding elements.
 * `Error` events are equal if errors have same domain and code for `NSError` representation and have equal descriptions.
 * `Completed` events are always equal.

 - parameter lhs: first set of events.
 - parameter lhs: second set of events.
 */
public func XCTAssertEqual(_ lhs: [CompletableTimeEvent], _ rhs: [CompletableTimeEvent], file: StaticString = #file, line: UInt = #line) {
    let leftEquatable = lhs.map { AnyEquatable(target: $0, comparer: ==) }
    let rightEquatable = rhs.map { AnyEquatable(target: $0, comparer: ==) }
    #if os(Linux)
        XCTAssertEqual(leftEquatable, rightEquatable)
    #else
        XCTAssertEqual(leftEquatable, rightEquatable, file: file, line: line)
    #endif
    if leftEquatable == rightEquatable {
        return
    }

    printSequenceDifferences(lhs, rhs, ==)
}

func printSequenceDifferences<Element>(_ lhs: [Element], _ rhs: [Element], _ equal: (Element, Element) -> Bool) {
    print("Differences:")
    for (index, elements) in zip(lhs, rhs).enumerated() {
        let l = elements.0
        let r = elements.1
        if !equal(l, r) {
            print("lhs[\(index)]:\n    \(l)")
            print("rhs[\(index)]:\n    \(r)")
        }
    }

    let shortest = min(lhs.count, rhs.count)
    for (index, element) in lhs[shortest ..< lhs.count].enumerated() {
        print("lhs[\(index + shortest)]:\n    \(element)")
    }
    for (index, element) in rhs[shortest ..< rhs.count].enumerated() {
        print("rhs[\(index + shortest)]:\n    \(element)")
    }
}

