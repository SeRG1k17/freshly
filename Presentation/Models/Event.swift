//
//  Event.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import Foundation
import RxDataSources
import Domain
//
//struct Event: IdentifiableType, Identifiable, Equatable {
//
//    typealias ID = String
//    typealias Identity = ID
//
//    var id: ID
//    var identity: Identity {
//        id
//    }
//}

extension Domain.Event: IdentifiableType, Identifiable {
    
    public typealias ID = Int
    public typealias Identity = ID
    
    public var identity: Identity {
        id
    }
}
