//
//  Event.swift
//  Platform
//
//  Created by Sergey Pugach on 17.05.21.
//

import Foundation
import Domain

extension Event: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, isFavourite
        case date = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date: Date
        if
            let dateString = try? container.decodeIfPresent(String.self, forKey: .date),
            let dateValue = DateFormatter.iso8601.date(from: dateString)
           {
            date = dateValue
            
        } else {
            date = try container.decode(Date.self, forKey: .date)
        }
        
        self.init(
            id: try container.decode(Int.self, forKey: .id),
            title: try container.decode(String.self, forKey: .title),
            date: date,
            url: try container.decode(URL.self, forKey: .url),
            isFavourite: (try? container.decodeIfPresent(Bool.self, forKey: .isFavourite)) ?? false
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encode(id, forKey: .id)
        try encoder.encode(title, forKey: .title)
        try encoder.encode(url, forKey: .url)
        try encoder.encode(isFavourite, forKey: .isFavourite)
        try encoder.encode(date, forKey: .date)
    }
}

private extension DateFormatter {
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withFullDate,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]

        return formatter
    }()
}
