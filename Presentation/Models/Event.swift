//
//  Event.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import Foundation
import RxDataSources
import Domain

extension Domain.Event: IdentifiableType, Identifiable {
    
    public typealias ID = Int
    public typealias Identity = ID
    
    public var identity: Identity {
        id
    }
}
