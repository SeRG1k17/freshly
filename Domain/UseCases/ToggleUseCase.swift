//
//  ToggleUseCase.swift
//  Domain
//
//  Created by Sergey Pugach on 19.05.21.
//

import RxSwift

public protocol ToggleUseCaseProtocol {
    func toggle(_ event: Event) -> Completable
}

public class ToggleUseCase {
    
    private let eventsRepository: EventsRepositoryProtocol
    public init(eventsRepository: EventsRepositoryProtocol) {
        self.eventsRepository = eventsRepository
    }
}


// MARK: - ToggleUseCaseProtocol

extension ToggleUseCase: ToggleUseCaseProtocol {
    
    public func toggle(_ event: Event) -> Completable {
        return eventsRepository.events
            .take(1)
            .asSingle()
            .map({ (events: [Event]) -> [Event] in
                guard let index = events.firstIndex(of: event) else { return events }
                
                var event = event
                event.isFavourite.toggle()
                
                var events = events
                events[index] = event
                
                return events
            })
            .flatMapCompletable({ self.eventsRepository.set($0) })
    }
}
