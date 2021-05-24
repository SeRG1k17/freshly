//
//  Event+Helpers.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 23.05.21.
//

import Domain
@testable import Platform

extension Domain.Event {
    
    static func make(_ count: Int) -> [Self] {
        (0..<count).map({ _ in Self.make() })
    }
    
    static func make() -> Self {
        return Self.init(
            id: Int.random(in: 0...Int.max),
            title: "event",
            date: Date(),
            url: URL(string: "google.com")!,
            isFavourite: false
            )
    }
    
    var data: Data {
        try! JSONEncoder().encode(self)
    }
}

extension Array where Element == Domain.Event {
    
    static func events(_ count: Int) -> [Element] {
        (0..<count).map({ _ in Element.make() })
    }
    
    var data: Data {
        try! JSONEncoder().encode(self)
    }
}

extension Container {
    
    static func make(events: [Domain.Event]) -> Self {
        Self.init(events: events)
    }
    
    var data: Data {
        try! JSONEncoder().encode(self)
    }
}

