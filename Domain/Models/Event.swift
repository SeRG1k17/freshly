//
//  Event.swift
//  Domain
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation

public struct Event {
    
    public let id: Int
    public let title: String
    public let date: Date
    public let url: URL
    public var isFavourite: Bool
    
    public init(id: Int, title: String, date: Date, url: URL, isFavourite: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.url = url
        self.isFavourite = isFavourite
    }
}

extension Event: Equatable {}
