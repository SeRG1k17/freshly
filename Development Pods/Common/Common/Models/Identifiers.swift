//
//  Identifiers.swift
//  Presentation
//
//  Created by Sergey Pugach on 24.05.21.
//

import Foundation

public enum Identifier {
    public enum Events: String {
        case table
        
        public var rawValue: String {
            "\(Identifier.self).\(Events.self).\(self)"
        }
        
        public enum Table {
            public enum Cell: String {
                case title, date, favourite
                
                public var rawValue: String {
                    "\(Identifier.self).\(Events.self).\(Table.self).\(Cell.self).\(self)"
                }
            }
        }
    }
    
    public enum Favourites: String {
        case table
        
        public var rawValue: String {
            "\(Identifier.self).\(Favourites.self).\(self)"
        }
    }
    
    public enum Tab: String {
        case events, favourites
        
        public var rawValue: String {
            "\(Identifier.self).\(Tab.self).\(self)"
        }
    }
}
