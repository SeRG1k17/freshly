//
//  FavouritesUseCase.swift
//  Domain
//
//  Created by Sergey Pugach on 19.05.21.
//

import RxSwift

public protocol FavouritesUseCaseProtocol {
    var events: Observable<[Event]> { get }
}

public class FavouritesUseCase {
    
    private let eventsRepository: EventsRepositoryProtocol
    public init(eventsRepository: EventsRepositoryProtocol) {
        self.eventsRepository = eventsRepository
    }
}

// MARK: - FavouritesUseCaseProtocol

extension FavouritesUseCase: FavouritesUseCaseProtocol {
    
    public var events: Observable<[Event]> {
        eventsRepository.events
            .map({ $0.filter({ $0.isFavourite }) })
            .distinctUntilChanged()
    }
}

