//
//  EventsRepositoryProtocol.swift
//  Domain
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation
import RxSwift

public protocol EventsRepositoryProtocol {
    
    var events: Observable<[Event]> { get }
    func update() -> Completable
    func refresh() -> Completable
    func set(_ events: [Event]) -> Completable
}
