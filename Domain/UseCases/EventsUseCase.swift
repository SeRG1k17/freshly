//
//  EventsUseCase.swift
//  Domain
//
//  Created by Sergey Pugach on 11.05.21.
//

import RxSwift

public protocol EventsUseCaseProtocol {
    var events: Observable<[Event]> { get }
    func update() -> Completable
    func refresh() -> Completable
}

public class EventsUseCase {
    
    private let eventsRepository: EventsRepositoryProtocol
    public init(eventsRepository: EventsRepositoryProtocol) {
        self.eventsRepository = eventsRepository
    }
}

// MARK: - EventsUseCaseProtocol

extension EventsUseCase: EventsUseCaseProtocol {
    
    public var events: Observable<[Event]> {
        eventsRepository.events
    }
    
    public func update() -> Completable {
        eventsRepository.update()
    }
    
    public func refresh() -> Completable {
        eventsRepository.refresh()
    }
}
